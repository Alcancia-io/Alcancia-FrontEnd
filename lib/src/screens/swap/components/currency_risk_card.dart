import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_container.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:flutter/material.dart';

class CurrencyRiskCard extends StatelessWidget {
  final RiskLevel riskLevel;
  final String targetCurrency;
  final Color color;
  final String percentage;

  const CurrencyRiskCard({
    super.key,
    required this.riskLevel,
    required this.targetCurrency,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    var theme = Theme.of(context).brightness.name;
    var lowRisk = {"light": alcanciaLowRiskLight, "dark": alcanciaLowRiskDark};
    var mediumRisk = {"light": alcanciaMediumRiskLight, "dark": alcanciaMediumRiskDark};
    var riskLevelColor = riskLevel == RiskLevel.bajo ? lowRisk[theme] : mediumRisk[theme];

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
                TextSpan(text: 'Nivel de riesgo: ', style: txtTheme.bodyMedium),
                TextSpan(text: riskLevel.name, style: TextStyle(color: riskLevelColor)),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'El rendimiento anual de $targetCurrency es de ', style: txtTheme.bodyMedium),
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
        ],
      ),
    );
  }
}
