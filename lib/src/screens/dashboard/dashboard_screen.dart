import 'dart:async';
import 'package:alcancia/firebase_remote_config.dart';
import 'package:alcancia/src/screens/dashboard/dashboard_controller.dart';
import 'package:alcancia/src/screens/error/error_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:alcancia/src/shared/components/dashboard/dashboard_actions.dart';
import 'package:alcancia/src/shared/models/remote_config_data.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:alcancia/src/shared/provider/transactions_provider.dart';
import 'package:alcancia/src/shared/services/metamap_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../shared/provider/balance_hist_provider.dart';
import '../../shared/provider/user_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? timer;
  final DashboardController dashboardController = DashboardController();
  final MetamapService metamapService = MetamapService();
  bool _isLoading = false;
  String _error = "";
  int attemptsAuth = 0;
  var name = "";

  Future<void> setUserInformation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userInfo = await dashboardController.fetchUserInformation();
      var balance = await dashboardController.fetchUserBalance();
      /*final isInCampaign = await dashboardController.campaignUserExists();
      if (isInCampaign) {
        final code = await dashboardController.getReferralCode();
        userInfo.user.referralCode = code;
      } Habilitar cuando campaña vuelva a estar ok*/
      var balanceHist = await dashboardController.fetchUserBalanceHistory();
      ref.read(balanceHistProvider.notifier).state = balanceHist;
      ref.read(balanceProvider.notifier).setBalance(balance);
      ref.read(transactionsProvider.notifier).state = userInfo.txns;
      ref.read(userProvider.notifier).setUser(userInfo.user);
    } catch (err) {
      setState(() {
        _error = err.toString();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> setUserBalance() async {
    try {
      var balance = await dashboardController.fetchUserBalance();
      ref.watch(balanceProvider.notifier).setBalance(balance);
    } catch (err) {
      return Future.error(err);
    }
  }

  void setTimer() {
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => setUserBalance());
  }

  @override
  void initState() {
    super.initState();

    setUserInformation();
    setTimer();
    /*var remoteConfig = FirebaseRemoteConfig.instance;
    name = remoteConfig.getString("name_test");
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      setState(() {
        name = remoteConfig.getString("name_test");
      });
    });*/ //Test remote config
    fetchRemoteConfig();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchRemoteConfig() async {
    String configJson = "";
    var remoteConfigProvider = ref.read(firebaseRemoteConfigServiceProvider);
    await remoteConfigProvider.remoteConfig.fetchAndActivate();
    remoteConfigProvider.remoteConfig.onConfigUpdated.listen((event) {
      configJson = remoteConfigProvider.getAppVariables();
      RemoteConfigData remoteConfigData =
          remoteConfigProvider.parseRemoteConfigData(configJson);
      ref.read(remoteConfigDataStateProvider.notifier).state = remoteConfigData;
    });
    configJson = remoteConfigProvider.getAppVariables();
    if (configJson.isNotEmpty) {
      try {
        RemoteConfigData remoteConfigData =
            remoteConfigProvider.parseRemoteConfigData(configJson);
        ref.read(remoteConfigDataStateProvider.notifier).state =
            remoteConfigData;

        // Access countries
        remoteConfigData.countryConfig.forEach((key, value) {
          print('Country: $key');
          print('Enabled: ${value.enabled}');
        });
      } on Exception catch (e) {
        throw e;
      }
    } else {
      print('Config JSON is empty or not available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    final txns = ref.watch(transactionsProvider);
    final screenSize = MediaQuery.of(context).size;
    final appLoc = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }
    if (_error != "")
      return ErrorScreen(
        error: _error,
      );
    return Scaffold(
      appBar: AlcanciaToolbar(
        state: StateToolbar.profileTitleIcon,
        logoHeight: 38,
        userName: user?.name,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          child: RefreshIndicator(
            onRefresh: () => setUserInformation(),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 16, top: 10),
                  child: const DashboardCard(),
                ),
                DashboardActions(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 22, top: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appLoc.labelActivity,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AlcanciaButton(
                        buttonText: appLoc.buttonSeeMore,
                        icon: SvgPicture.asset(
                            "lib/src/resources/images/plus_icon.svg"),
                        onPressed: () {
                          context.go("/homescreen/1");
                        },
                        color: const Color(0x00FFFFFF),
                        rounded: true,
                        height: 24,
                      ),
                    ],
                  ),
                ),
                AlcanciaTransactions(
                  height: screenSize.height * 0.5,
                  txns: txns,
                  bottomText: appLoc.labelStartTransactionDashboard,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
