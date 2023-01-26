import 'package:alcancia/src/shared/components/alcancia_container.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:flutter/material.dart';

class CurrencyRiskCard extends StatelessWidget {
  final RiskLevel riskLevel;
  final String targetCurrency;
  final Color color;
  final double percentage;

  const CurrencyRiskCard({
    super.key,
    required this.riskLevel,
    required this.targetCurrency,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return AlcanciaContainer(
      top: 16,
      bottom: 16,
      left: 16,
      right: 16,
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nivel de riesgo: ${riskLevel.name}'),
          Text('El rendimiento anual de $targetCurrency es de $percentage%')
        ],
      ),
    );
  }
}
