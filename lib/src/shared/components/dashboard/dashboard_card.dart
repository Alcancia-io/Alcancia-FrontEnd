import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/dashboard/balance_carousel.dart';
import 'package:alcancia/src/shared/provider/balance_hist_provider.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../screens/chart/alcancia_line_chart.dart';

class DashboardCard extends ConsumerStatefulWidget {
  const DashboardCard({Key? key}) : super(key: key);

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends ConsumerState<DashboardCard>
    with TickerProviderStateMixin {
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
          BalanceCarousel(
            balance: userBalance,
            redirectToGraph: () {
              context.go("/homescreen/1");
            },
          ),
        ],
      ),
    );
  }
}
