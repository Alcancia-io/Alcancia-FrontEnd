import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/features/transaction-detail/presentation/transaction_detail_item.dart';
import 'package:go_router/go_router.dart';

import '../../../resources/colors/colors.dart';
import '../../../shared/models/transaction_model.dart';

class TransactionDetail extends StatelessWidget {
  const TransactionDetail({Key? key, required this.txn}) : super(key: key);
  final Transaction txn;

  @override
  Widget build(BuildContext context) {
    var ctx = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: EdgeInsets.all(18),
              height: 430,
              decoration: BoxDecoration(
                color: ctx.brightness == Brightness.dark
                    ? alcanciaCardDark2
                    : alcanciaCardLight2,
                borderRadius: BorderRadius.all(
                  Radius.circular(11),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 48, top: 8),
                    child: Text(
                      'Detalle de la actividad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TransactionDetailItem(
                    leftText: 'Fecha',
                    rightText: '${txn.createdAt}',
                  ),
                  TransactionDetailItem(
                    leftText: 'Id transacción',
                    rightText:
                        '${txn.transactionID.substring(0, txn.transactionID.indexOf('-'))}',
                  ),
                  TransactionDetailItem(
                    leftText: 'Valor depósito',
                    rightText: '\$${txn.sourceAmount.toStringAsFixed(2)}',
                  ),
                  TransactionDetailItem(
                    leftText: 'Valor USDC',
                    rightText: '\$${txn.amount.toStringAsFixed(2)}',
                  ),
                  TransactionDetailItem(
                    leftText: 'Tipo de TXN',
                    rightText: '${txn.type.isDepositOrWithdraw()}',
                  ),
                  TransactionDetailItem(
                    leftText: 'Estatus',
                    rightIcon: txn.iconForTxnStatus,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF4E76E5),
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        child: Text("Cerrar"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
