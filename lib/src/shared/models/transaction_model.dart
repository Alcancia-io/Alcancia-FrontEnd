import 'package:flutter/material.dart';

class Transaction {
  String transactionID;
  String createdAt;
  int sourceAmount;
  String sourceAsset;
  String targetAsset;
  int amount;
  String type;
  String status;

  Transaction({
    required this.transactionID,
    required this.createdAt,
    required this.sourceAmount,
    required this.sourceAsset,
    required this.targetAsset,
    required this.amount,
    required this.type,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    var targetAsset = json["targetAsset"] as String;
    if (targetAsset == "aPolUSDC") targetAsset = "USDC";
    return Transaction(
      transactionID: json["id"] as String,
      createdAt: json["createdAt"] as String,
      sourceAmount: json["sourceAmount"] as int,
      sourceAsset: json["sourceAsset"] as String,
      targetAsset: targetAsset,
      amount: json["amount"] as int,
      type: json["type"] as String,
      status: json["status"] as String
    );
  }
}


extension StatusIcon on Transaction {
  Icon get iconForTxnStatus {
    if (status == "PENDING") return const Icon(Icons.hourglass_bottom_rounded);
    if (status == "COMPLETED") return const Icon(Icons.check, color: Colors.green,);
    return const Icon(Icons.close, color: Colors.red,);
  }
}