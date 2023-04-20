import 'package:alcancia/src/shared/models/currency_asset.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Transaction {
  String transactionID;
  String createdAt;
  double sourceAmount;
  String sourceAsset;
  String targetAsset;
  double amount;
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
    final targetAsset = json["targetAsset"] as String;
    final sourceAsset = json["sourceAsset"] as String;
    return Transaction(
        transactionID: json["id"] as String,
        createdAt: json["createdAt"] as String,
        sourceAmount: double.parse(json["sourceAmount"].toString()),
        sourceAsset:
            CurrencyAsset.values.firstWhereOrNull((e) => e.actualAsset == sourceAsset)?.shownAsset ?? sourceAsset,
        targetAsset:
            CurrencyAsset.values.firstWhereOrNull((e) => e.actualAsset == targetAsset)?.shownAsset ?? sourceAsset,
        amount: double.parse(json["amount"].toString()),
        type: json["type"] as String,
        status: json["status"] as String);
  }
}

extension StatusIcon on Transaction {
  Widget get iconForTxnStatus {
    if (status == "PENDING") return Image.asset("lib/src/resources/images/hourglass_flowing_sand.png", width: 24,);
    if (status == "COMPLETED") {
      return Image.asset("lib/src/resources/images/white_check_mark.png", width: 24,);
    }
    return Image.asset("lib/src/resources/images/x.png", width: 24,);
  }
}
