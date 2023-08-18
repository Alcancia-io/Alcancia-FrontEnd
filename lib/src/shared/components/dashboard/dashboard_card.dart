import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/dashboard/balance_carousel.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../screens/chart/alcancia_line_chart.dart';

class DashboardCard extends ConsumerStatefulWidget {
  const DashboardCard({Key? key}) : super(key: key);

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends ConsumerState<DashboardCard>
    with TickerProviderStateMixin {
  bool visibleChart = false;
  late AnimationController _slideController;
  late AnimationController _sizeController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();

    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      visibleChart = !visibleChart;
      if (visibleChart) {
        _sizeController.forward();
      } else {
        _sizeController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final userBalance = ref.watch(balanceProvider);

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1.0, 0.0), // Slide in from the left
        end: Offset(0.0, 0.0),
      ).animate(_slideController),
      child: Container(
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
            BalanceCarousel(
              balance: userBalance,
              toggleVisibility: toggleVisibility,
            ),
            AnimatedBuilder(
              animation: _sizeController,
              builder: (context, child) {
                return SizeTransition(
                  axisAlignment: -1.0,
                  sizeFactor: _sizeController,
                  child: const Center(
                    child: SizedBox(
                      height: 300,
                      width: 500,
                      child: AlcanciaLineChart(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
