import 'package:alcancia/src/shared/components/alcancia_transaction_item.dart';
import 'package:alcancia/src/shared/models/transaction.dart';
import 'package:flutter/material.dart';

class AlcanciaTransactions extends StatelessWidget {
  final List<Transaction>? transactions;
  final double? height;

  const AlcanciaTransactions(
      {Key? key, required this.transactions, this.height})
      : super(key: key);

  factory AlcanciaTransactions.fromJson(Map<String, dynamic> json) =>
      AlcanciaTransactions(
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

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    if (transactions?.length == 0) {
      return Text(
        "Sin registros aún...",
        style: txtTheme.titleLarge,
      );
    }
    return SizedBox(
      height: height,
      child: ListView.builder(
        itemCount: transactions?.length,
        itemBuilder: (BuildContext context, int index) {
          var txn = transactions?[index];
          return AlcanciaTransactionItem(
            txn: txn as Transaction,
          );
        },
      ),
    );
  }
}
