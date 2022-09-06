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
  // final List<Transaction> transactions;
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
    if (transactions.transactions?.length == 0) {
      return Text(
        "Sin registros aún...",
        style: Theme.of(context).textTheme.titleLarge,
      );
    }
    return Column(
      children: [
        Column(
          children: [
            for (var item
                in transactions.getTransactions() as List<Transaction>)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
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
                                style: TextStyle(fontSize: 13),
                              ),
                              Text("${item.createdAt}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${item.sourceAmount}"),
                        Text("${item.amount} ${item.targetAsset}"),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
