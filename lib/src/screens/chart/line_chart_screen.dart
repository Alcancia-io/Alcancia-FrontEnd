import 'package:alcancia/src/shared/components/alcancia_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/components/alcancia_toolbar.dart';
import '../../shared/components/alcancia_transactions_list.dart';
import '../../shared/models/balance_history_model.dart';
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
    var userValue = ref.watch(alcanciaUserProvider);
    final txns = ref.watch(transactionsProvider);
    final screenSize = MediaQuery.of(context).size;
    final appLoc = AppLocalizations.of(context)!;
    return userValue.when(
        data: (user) {
          final balHist = user.balanceHistory.where((data) =>
          data.createdAt!.isBefore(DateTime.now()) &&
              data.createdAt!.isAfter(DateTime.now().subtract(const Duration(days: 365))))
              .toList();
          Map<int, Map<int, UserBalanceHistory>> groupedByYearAndMonth = {};

          for (var history in balHist) {
            int year = history.createdAt!.year;
            int month = history.createdAt!.month;

            if (!groupedByYearAndMonth.containsKey(year)) {
              groupedByYearAndMonth[year] = {};
            }

            if (!groupedByYearAndMonth[year]!.containsKey(month) ||
                history.createdAt!.day > groupedByYearAndMonth[year]![month]!.createdAt!.day) {
              groupedByYearAndMonth[year]![month] = history;
            }
          }

          // Create a list of the selected items
          List<UserBalanceHistory> selectedHistories = [];

          groupedByYearAndMonth.values.forEach((monthMap) {
            selectedHistories.addAll(monthMap.values);
          });
          selectedHistories.sort(((a, b) => a.createdAt!.compareTo(b.createdAt!)));
          return Scaffold(
            appBar: AlcanciaToolbar(
              state: StateToolbar.profileTitleIcon,
              logoHeight: 38,
              userName: user.name,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 0),
                      child: Center(
                        child: AlcanciaLineChart(balanceHist: selectedHistories),
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
        },
        error: (error, _) {
          return AlcanciaErrorWidget();
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
