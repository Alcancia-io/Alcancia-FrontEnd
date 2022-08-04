class Transaction {
  String transactionID;
  String createdAt;
  double sourceAmount;
  String sourceAsset;
  String targetAsset;
  double amount;
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
}
