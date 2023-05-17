import 'package:alcancia/src/shared/models/currency_asset.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Transaction {
  String transactionID;
  String createdAt;
  double? sourceAmount;
  String sourceAsset;
  String? targetAsset;
  double amount;
  TransactionType type;
  String status;
  String? senderId;
  String? receiverId;

  Transaction({
    required this.transactionID,
    required this.createdAt,
    required this.sourceAmount,
    required this.sourceAsset,
    required this.targetAsset,
    required this.amount,
    required this.type,
    required this.status,
    required this.senderId,
    required this.receiverId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final targetAsset = json["targetAsset"].toString();
    final sourceAsset = json["sourceAsset"].toString();
    return Transaction(
        transactionID: json["id"] as String,
        createdAt: json["createdAt"] as String,
        sourceAmount: double.tryParse(json["sourceAmount"].toString()),
        sourceAsset:
            CurrencyAsset.values.firstWhereOrNull((e) => e.actualAsset.toLowerCase() == sourceAsset.toLowerCase())?.shownAsset ?? sourceAsset,
        targetAsset:
            CurrencyAsset.values.firstWhereOrNull((e) => e.actualAsset.toLowerCase() == targetAsset.toLowerCase())?.shownAsset,
        amount: double.parse(json["amount"].toString()),
        type: TransactionType.values.firstWhere((e) => e.name.toUpperCase() == json["type"], orElse: () => TransactionType.unknown),
        status: json["status"] as String,
        senderId: json["senderId"],
        receiverId: json["receiverId"],
    );
  }
}

extension StatusIcon on Transaction {
  Widget iconForTxnStatus(String currentUserId) {
    if (status == "PENDING") return SvgPicture.asset("lib/src/resources/images/pending.svg", width: 24,);
    if (status == "COMPLETED") {
      if (type == TransactionType.deposit || receiverId == currentUserId) return SvgPicture.asset("lib/src/resources/images/deposit.svg", width: 24,);
      if (type == TransactionType.withdraw || senderId == currentUserId) return SvgPicture.asset("lib/src/resources/images/withdrawal.svg", width: 24,);
    }
    // FAILED or EXPIRED
    return SvgPicture.asset("lib/src/resources/images/failed.svg", width: 24,);
  }
}
