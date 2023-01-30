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
    var riskLevelColor = riskLevel == RiskLevel.bajo ? const Color(0xff00FF98) : const Color(0xffA0FF26);
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
                const TextSpan(text: 'Nivel de riesgo: '),
                TextSpan(text: riskLevel.name, style: TextStyle(color: riskLevelColor)),
              ],
            ),
          ),
          Text('El rendimiento anual de $targetCurrency es de $percentage')
        ],
      ),
    );
  }
}
