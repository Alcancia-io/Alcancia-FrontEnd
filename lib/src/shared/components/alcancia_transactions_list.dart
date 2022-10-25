import 'package:alcancia/src/shared/components/alcancia_transaction_item.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:flutter/material.dart';

class AlcanciaTransactions extends StatelessWidget {
  final List<Transaction> txns;
  final double? height;

  const AlcanciaTransactions({
    Key? key,
    required this.txns,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    if (txns.isEmpty) {
      return Text(
        "Sin registros aún...",
        style: txtTheme.titleLarge,
      );
    }
    return SizedBox(
      height: height,
      child: ListView.builder(
        itemCount: txns.length,
        itemBuilder: (BuildContext context, int index) {
          var txn = txns[index];
          return AlcanciaTransactionItem(
            txn: txn,
          );
        },
      ),
    );
  }
}
