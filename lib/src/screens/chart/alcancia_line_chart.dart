import 'package:alcancia/src/shared/models/balance_history_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class _LineChart extends StatelessWidget {
  const _LineChart(
      {required this.isShowingMainData, required this.balanceHist});

  final bool isShowingMainData;
  final List<UserBalanceHistory> balanceHist;
  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 20),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: balanceHist.length.toDouble() - 1,
        maxY: balanceHist
                .map((data) => data.balance)
                .reduce((a, b) => a! > b! ? a : b)! *
            1.35, //Max Balance with margin of 20 units
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String? text;
    double maxBalance = balanceHist
        .map((data) => data.balance)
        .reduce((a, b) => a! > b! ? a : b)!;
    List<int> balanceParts = List.generate(6, (index) => maxBalance ~/ 6);
    int sumCumulative = 0;
    for (int i = 0; i < balanceParts.length; i++) {
      sumCumulative += balanceParts[i];
      if (value.toInt() == sumCumulative) {
        text = sumCumulative.toString();
      }
    }
    if (text == null) {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    DateTime? minDate = balanceHist.map((history) => history.createdAt).reduce(
        (value, element) => value!.isBefore(element!) ? value : element);

    DateTime? maxDate = balanceHist
        .map((history) => history.createdAt)
        .reduce((value, element) => value!.isAfter(element!) ? value : element);
    int monthDifference =
        (maxDate!.year - minDate!.year) * 12 + maxDate.month - minDate.month;
    Widget? text;

    if (monthDifference >= value.toInt()) {
      text = Text(
          DateFormat("MMM")
              .format(balanceHist[value.toInt()].createdAt!)
              .toString()
              .toUpperCase(),
          style: style);
    }

    if (text == null) {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 26,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: const Color(0xFF4E76E5).withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: false,
        color: const Color(0xFF4E76E5),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: true),
        spots: balanceHist.asMap().entries.map((entry) {
          int index = entry.key;
          UserBalanceHistory data = entry.value;
          return FlSpot(index.toDouble(), data.balance!.toDouble());
        }).toList(),
      );
}

class AlcanciaLineChart extends StatefulWidget {
  const AlcanciaLineChart(
      {super.key, required this.balanceHist, this.showTitle = true});

  final List<UserBalanceHistory> balanceHist;
  final bool showTitle;

  @override
  State<StatefulWidget> createState() => _AlcanciaLineChart();
}

class _AlcanciaLineChart extends State<AlcanciaLineChart> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              if (widget.showTitle) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    appLoc.labelChartBalance,
                    style: const TextStyle(
                      color: Color(0xFF4E76E5),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
              const SizedBox(
                height: 27,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(
                    isShowingMainData: isShowingMainData,
                    balanceHist: widget.balanceHist,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.refresh,
          //     color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       isShowingMainData = !isShowingMainData;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
