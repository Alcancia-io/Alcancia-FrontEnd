class ExternalWithdrawal {
  final String amount;
  final String receiverAddress;
  final String senderAddress;
  final String token;

  ExternalWithdrawal({
    required this.amount,
    required this.receiverAddress,
    required this.senderAddress,
    required this.token,
  });

  factory ExternalWithdrawal.fromJSON(Map<String, dynamic> map) {
    return ExternalWithdrawal(
      amount: map["amount"]?.toString() ?? "",
      receiverAddress: map["receiverAddress"],
      senderAddress: map["senderAddress"],
      token: map["token"],
    );
  }
}
