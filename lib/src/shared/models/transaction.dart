class Transaction {
  String transactionID;
  String createdAt;
  int sourceAmount;
  String sourceAsset;
  String targetAsset;
  int amount;
  String type;

  Transaction({
    required this.transactionID,
    required this.createdAt,
    required this.sourceAmount,
    required this.sourceAsset,
    required this.targetAsset,
    required this.amount,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionID: json["transactionID"] as String,
      createdAt: json["createdAt"] as String,
      sourceAmount: json["sourceAmount"] as int,
      sourceAsset: json["sourceAsset"] as String,
      targetAsset: json["targetAsset"] as String,
      amount: json["amount"] as int,
      type: json["type"] as String,
    );
  }
}
