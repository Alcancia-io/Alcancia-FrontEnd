class SuarmiOrder {
  String address;
  String? concept;
  String sourceAmount;
  String targetCurrency;
  String network;
  String uuid;

  SuarmiOrder({
    required this.address,
    this.concept,
    required this.sourceAmount,
    required this.targetCurrency,
    required this.network,
    required this.uuid,
  });

  factory SuarmiOrder.fromJson(Map<String, dynamic> json) {
    return SuarmiOrder(
      address: json["address"] as String,
      concept: json["concepto"],
      sourceAmount: json["from_amount"] as String,
      network: json['network'],
      targetCurrency: json['to_currency'],
      uuid: json['uuid'],
    );
  }
}
