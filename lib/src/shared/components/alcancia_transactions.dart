import 'package:alcancia/src/shared/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Data {
  List<Transaction>? transactions;
  Data({required this.transactions});
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactions: json['items'] == null
            ? null
            : List<Transaction>.from(
                json['items'].map(
                  (txn) => Transaction.fromJson(txn),
                ),
              ),
      );

  List<Transaction>? getTransactions() {
    return transactions;
  }
}

class AlcanciaTransactions extends StatelessWidget {
  final Data transactions;

  const AlcanciaTransactions({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  String getImageType(String txnType) {
    if (txnType == "WITHDRAW") {
      return "lib/src/resources/images/withdraw.svg";
    }
    return "lib/src/resources/images/deposit.svg";
  }

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    if (transactions.transactions?.length == 0) {
      return Text(
        "Sin registros aún...",
        style: txtTheme.titleLarge,
      );
    }
    return Column(
      children: [
        for (var item in transactions.getTransactions() as List<Transaction>)
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF1F318C)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      getImageType(item.type),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item.type} ${item.sourceAsset}",
                            style: txtTheme.bodyText2,
                          ),
                          Text(item.createdAt),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("\$${item.sourceAmount.toStringAsFixed(2)}"),
                          Text(
                              "${item.amount.toStringAsFixed(2)} ${item.targetAsset}"),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "lib/src/resources/images/white_arrow_right.svg",
                    )
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
