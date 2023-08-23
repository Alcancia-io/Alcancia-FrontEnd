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
      duration: const Duration(milliseconds: 2),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: null,
        maxY: balanceHist
                .map((data) => data.balance)
                .reduce((a, b) => a! > b! ? a : b)! +
            20.0, //Max Balance
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
        leftTitles: AxisTitles(
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
            .reduce((a, b) => a! > b! ? a : b)! +
        20.0;
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
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('ENE', style: style);
        break;
      case 2:
        text = const Text('FEB', style: style);
        break;
      case 3:
        text = const Text('MAR', style: style);
        break;
      case 4:
        text = const Text('ABR', style: style);
        break;
      case 5:
        text = const Text('MAY', style: style);
        break;
      case 6:
        text = const Text('JUN', style: style);
        break;
      case 7:
        text = const Text('JUL', style: style);
        break;
      case 8:
        text = const Text('AGO', style: style);
        break;
      case 9:
        text = const Text('SEP', style: style);
        break;
      case 10:
        text = const Text('OCT', style: style);
        break;
      case 11:
        text = const Text('NOV', style: style);
        break;
      case 12:
        text = const Text('DIC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 2,
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
        isCurved: true,
        color: const Color(0xFF4E76E5),
        barWidth: 3,
        isStrokeCapRound: false,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: true),
        spots: balanceHist
        .where((data) => data.createdAt!.isBefore(DateTime.now()) && data.createdAt!.isAfter(DateTime.now().subtract(const Duration(days: 365))))
            .map((data) =>
                FlSpot(data.createdAt!.month.toDouble(), data.balance!))
            .toList(),
      );
}

class AlcanciaLineChart extends StatefulWidget {
  const AlcanciaLineChart({super.key, required this.balanceHist, this.showTitle = true});

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
              if (widget.showTitle) ... [
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
