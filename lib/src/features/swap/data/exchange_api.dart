class ExchangeApi {
  final String result;
  final String baseCode;
  final String targetCode;
  final double conversionRate;

  const ExchangeApi({
    required this.result,
    required this.baseCode,
    required this.targetCode,
    required this.conversionRate,
  });

  factory ExchangeApi.fromJson(Map<String, dynamic> json) {
    return ExchangeApi(
      result: json['result'],
      baseCode: json['base_code'],
      targetCode: json['target_code'],
      conversionRate: json['conversion_rate'],
    );
  }
}
