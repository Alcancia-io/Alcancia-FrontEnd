import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_transaction_item.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlcanciaTransactions extends StatelessWidget {
  final List<Transaction> txns;
  final double? height;
  final String bottomText;

  const AlcanciaTransactions({
    Key? key,
    required this.txns,
    required this.bottomText,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    if (txns.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: appTheme.brightness == Brightness.dark ? alcanciaCardDark2 : alcanciaCardLight2,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                "lib/src/resources/images/no_transactions.png",
                color: Colors.white70,
                height: 80,
              ),
            ),
            Text(
              appLoc.labelNoTransactions,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              bottomText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
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
