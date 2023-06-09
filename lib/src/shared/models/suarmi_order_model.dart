class AlcanciaOrder {
  String? address;
  String? concept;
  String sourceAmount;
  String sourceCurrency;
  String targetCurrency;
  String network;
  String uuid;

  AlcanciaOrder({
    required this.address,
    this.concept,
    required this.sourceAmount,
    required this.sourceCurrency,
    required this.targetCurrency,
    required this.network,
    required this.uuid,
  });

  factory AlcanciaOrder.fromJson(Map<String, dynamic> json) {
    return AlcanciaOrder(
      address: json["address"] as String?,
      concept: json["concepto"],
      sourceCurrency: json["from_currency"] as String,
      sourceAmount: json["from_amount"] as String,
      network: json['network'],
      targetCurrency: json['to_currency'],
      uuid: json['uuid'],
    );
  }
}
