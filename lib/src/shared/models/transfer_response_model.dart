class TransferResponse {
  final double amount;
  final DateTime createdAt;
  final String id;
  final String receiverId;
  final String receiverLastName;
  final String receiverName;
  final String senderId;
  final String token;

  TransferResponse({
    required this.amount,
    required this.createdAt,
    required this.id,
    required this.receiverId,
    required this.receiverLastName,
    required this.receiverName,
    required this.senderId,
    required this.token,
  });

  factory TransferResponse.fromJSON(Map<String, dynamic> map) {
    final date = DateTime.parse(map["createdAt"]);
    return TransferResponse(
      amount: double.parse(map["amount"].toString()),
      createdAt: date,
      id: map["id"],
      receiverId: map["receiverId"],
      receiverLastName: map["receiverLastName"],
      receiverName: map["receiverName"],
      senderId: map["senderId"],
      token: map["token"],
    );
  }
}
