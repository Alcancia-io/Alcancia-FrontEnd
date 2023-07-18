import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_container.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:alcancia/src/shared/extensions/risk_level_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CurrencyRiskCard extends StatelessWidget {
  final RiskLevel riskLevel;
  final String targetCurrency;
  final Color color;
  final String percentage;
  final String sourceCurrency;
  final double exchangeRate;

  const CurrencyRiskCard({
    super.key,
    required this.riskLevel,
    required this.targetCurrency,
    required this.color,
    required this.percentage,
    required this.sourceCurrency,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;
    var theme = Theme.of(context).brightness.name;
    var lowRisk = {"light": alcanciaLowRiskLight, "dark": alcanciaLowRiskDark};
    var mediumRisk = {"light": alcanciaMediumRiskLight, "dark": alcanciaMediumRiskDark};
    var riskLevelColor = riskLevel == RiskLevel.low ? lowRisk[theme] : mediumRisk[theme];

    return AlcanciaContainer(
      top: 16,
      bottom: 16,
      left: 16,
      right: 16,
      color: color,
      width: double.infinity,
      borderRadius: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: appLoc.labelRiskLevel, style: txtTheme.bodyMedium),
                TextSpan(text: riskLevel.toValue(appLoc), style: TextStyle(color: riskLevelColor)),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: appLoc.labelAPY(targetCurrency), style: txtTheme.bodyMedium),
                TextSpan(
                  text: percentage,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: txtTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "1 USDC = ${exchangeRate.toStringAsFixed(2)} $sourceCurrency",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: txtTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
