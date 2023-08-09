class ExternalWithdrawal {
  final String amount;
  final String receiverAddress;
  final String senderAddress;
  final String senderId;
  final String token;

  ExternalWithdrawal({
    required this.amount,
    required this.receiverAddress,
    required this.senderAddress,
    required this.senderId,
    required this.token,
  });

  factory ExternalWithdrawal.fromJSON(Map<String, dynamic> map) {
    return ExternalWithdrawal(
      amount: map["amount"],
      receiverAddress: map["receiverAddress"],
      senderAddress: map["senderAddress"],
      senderId: map["senderId"],
      token: map["token"],
    );
  }
}
