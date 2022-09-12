import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/features/transaction-detail/presentation/transaction_detail_item.dart';
import 'package:go_router/go_router.dart';

import '../../../resources/colors/colors.dart';
import '../../../shared/models/transaction.dart';

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
              height: 400,
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
                    rightText: '${txn.transactionID.substring(0,txn.transactionID.indexOf('-'))}',
                  ),
                  TransactionDetailItem(
                    leftText: 'Valor depósito',
                    rightText: '\$${txn.sourceAmount}',
                  ),
                  TransactionDetailItem(
                    leftText: 'Valor USDC',
                    rightText: '\$${txn.amount}',
                  ),
                  // TransactionDetailItem(
                  //   leftText: 'Comisión',
                  //   rightText: '${}',
                  // ),
                  TransactionDetailItem(
                    leftText: 'Tipo de TXN',
                    rightText: '${txn.type.isDepositOrWithdraw()}',
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.only(bottom: 64, top: 18),
                  //   child: Text(
                  //     'Descargar Detalle de la Actividad',
                  //     style: TextStyle(
                  //       color: Color(0xFF4E76E5),
                  //       fontSize: 15,
                  //       decoration: TextDecoration.underline,
                  //       decorationThickness: 4,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(

                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF4E76E5),
                        ),
                        onPressed: () {context.pop();},
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

// text
// fecha
// valor de deposito
// valor de usdt
// comision
// tipo de txn
// descargar
// button