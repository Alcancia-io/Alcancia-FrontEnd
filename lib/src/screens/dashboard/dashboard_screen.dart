import 'dart:async';
import 'dart:developer';
import 'package:alcancia/src/screens/dashboard/dashboard_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';

import '../../shared/provider/user_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? timer;
  final DashboardController dashboardController = DashboardController();
  late List<Transaction> txns;
  bool _isLoading = false;
  String _error = "";

  void setUserInformation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userInfo = await dashboardController.fetchUserInformation();
      inspect(userInfo);
      txns = userInfo.txns;
      ref.watch(userProvider.notifier).setUser(userInfo.user);
      ref
          .watch(balanceProvider.notifier)
          .setBalance(Balance(balance: userInfo.user.balance));
    } catch (err) {
      setState(() {
        _error = err.toString();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void setUserBalance() async {
    try {
      var balance = await dashboardController.fetchUserBalance();
      ref.watch(balanceProvider.notifier).setBalance(Balance(balance: balance));
    } catch (err) {}
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
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    if (_isLoading) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }
    if (_error != "") return SafeArea(child: Center(child: Text(_error)));
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AlcanciaNavbar(username: user!.name),
              Container(
                padding: const EdgeInsets.only(bottom: 16, top: 10),
                child: DashboardCard(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22, top: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Actividad",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AlcanciaButton(
                      buttonText: "Ver más",
                      onPressed: () {
                        context.push("/homescreen/1");
                      },
                      color: const Color(0x00FFFFFF),
                      rounded: true,
                      height: 24,
                    ),
                  ],
                ),
              ),
              AlcanciaTransactions(
                txns: txns,
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
