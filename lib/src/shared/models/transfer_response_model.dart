class TransferResponse {
  final String amount;
  final String destinationWallet;
  final String token;
  final String txnDate;
  final String destPhoneNumber;
  final String destUserName;
  final String txnId;

  TransferResponse({
    required this.amount,
    required this.destinationWallet,
    required this.token,
    required this.txnDate,
    required this.destPhoneNumber,
    required this.destUserName,
    required this.txnId,
  });

  factory TransferResponse.fromJSON(Map<String, dynamic> map) {
    return TransferResponse(
      amount: map["amount"],
      destinationWallet: map["destWallet"],
      token: map["token"],
      txnDate: map["createdAt"],
      destPhoneNumber: map["destPhoneNumber"],
      destUserName: map["destUserName"],
      txnId: map["id"],
    );
  }
}
