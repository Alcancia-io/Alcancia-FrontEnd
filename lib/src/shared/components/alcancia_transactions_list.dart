import 'package:alcancia/src/shared/components/alcancia_transaction_item.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final appLoc = AppLocalizations.of(context)!;
    if (txns.isEmpty) {
      return Text(
        appLoc.labelNoTransactions,
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
