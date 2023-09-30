import 'dart:async';

import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/dashboard/dashboard_controller.dart';
import 'package:alcancia/src/shared/components/dashboard/balance_carousel.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardCard extends ConsumerStatefulWidget {
  const DashboardCard({Key? key}) : super(key: key);

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends ConsumerState<DashboardCard>
    with TickerProviderStateMixin {
  final DashboardController dashboardController = DashboardController();
  Timer? timer;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    setInitialBalance();
    setTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void setTimer() {
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => setUserBalance());
  }

  Future<void> setUserBalance() async {
    try {
      var balance = await dashboardController.fetchUserBalance();
      ref.read(balanceProvider.notifier).setBalance(balance);
    } catch (err) {
      return Future.error(err);
    }
  }

  Future<void> setInitialBalance() async {
    setState(() {
      _loading = true;
    });
    await setUserBalance();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final userBalance = ref.watch(balanceProvider);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ctx.brightness == Brightness.dark
            ? alcanciaCardDark2
            : alcanciaCardLight2,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          if (_loading) ... [
            const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ] else ...[
            BalanceCarousel(
              balance: userBalance,
              redirectToGraph: () {
                context.go("/homescreen/1");
              },
            ),
          ]
        ],
      ),
    );
  }
}
