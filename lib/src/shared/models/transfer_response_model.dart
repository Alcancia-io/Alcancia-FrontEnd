class TransferResponse {
  final String amount;
  final String destinationWallet;
  final String sourceUserId;
  final String token;

  TransferResponse({
    required this.amount,
    required this.destinationWallet,
    required this.sourceUserId,
    required this.token,
  });

  factory TransferResponse.fromJSON(Map<String, dynamic> map) {
    return TransferResponse(
      amount: map["amount"],
      destinationWallet: map["destWallet"],
      sourceUserId: map["srcUserId"],
      token: map["token"],
    );
  }
}
