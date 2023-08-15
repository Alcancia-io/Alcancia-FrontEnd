import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../shared/components/alcancia_toolbar.dart';
import '../../shared/components/alcancia_transactions_list.dart';
import '../../shared/provider/alcancia_providers.dart';
import '../../shared/provider/transactions_provider.dart';
import 'alcancia_line_chart.dart';

class LineChartScreen extends ConsumerStatefulWidget {
  const LineChartScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LineChartScreen> createState() => _LineChartState();
}

class _LineChartState extends ConsumerState<LineChartScreen> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    final txns = ref.watch(transactionsProvider);
    final screenSize = MediaQuery.of(context).size;
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AlcanciaToolbar(
        state: StateToolbar.profileTitleIcon,
        logoHeight: 38,
        userName: user!.name,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: SizedBox(
                  height: 300,
                  width: 500,
                  child: AlcanciaLineChart(),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 0),
                child: AlcanciaTransactions(
                  height: screenSize.height * 0.4,
                  txns: txns,
                  bottomText: appLoc.labelStartTransactionDashboard,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
