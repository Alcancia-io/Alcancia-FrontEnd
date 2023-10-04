import 'package:alcancia/src/screens/dashboard/dashboard_controller.dart';
import 'package:alcancia/src/screens/error/error_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:alcancia/src/shared/components/dashboard/dashboard_actions.dart';
import 'package:alcancia/src/shared/services/metamap_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../shared/provider/user_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final DashboardController dashboardController = DashboardController();
  final MetamapService metamapService = MetamapService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userValue = ref.watch(alcanciaUserProvider);
    final screenSize = MediaQuery.of(context).size;
    final appLoc = AppLocalizations.of(context)!;

    return userValue.when(data: (user) {
      return Scaffold(
        appBar: AlcanciaToolbar(
          state: StateToolbar.profileTitleIcon,
          logoHeight: 38,
          userName: user.name,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                ref.refresh(alcanciaUserProvider);
              },
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
                    bottomText: appLoc.labelStartTransactionDashboard,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }, error: (error, _) {
      return ErrorScreen(
        error: error.toString(),
      );
    }, loading: () {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    });
  }
}
