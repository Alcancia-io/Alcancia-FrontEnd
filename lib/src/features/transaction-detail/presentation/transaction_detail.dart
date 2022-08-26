import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/features/transaction-detail/presentation/transaction_detail_item.dart';

class TransactionDetail extends StatelessWidget {
  const TransactionDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: EdgeInsets.all(18),
              height: 512,
              decoration: const BoxDecoration(
                color: Color(0xFF0F2346),
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
                  const TransactionDetailItem(
                    leftText: 'Fecha',
                    rightText: '01/Abr/21',
                  ),
                  const TransactionDetailItem(
                    leftText: 'Id transacción',
                    rightText: '123456789',
                  ),
                  const TransactionDetailItem(
                    leftText: 'Valor depósito',
                    rightText: '\$280.89 MXN',
                  ),
                  const TransactionDetailItem(
                    leftText: 'Valor USDC',
                    rightText: '0.01 USDC',
                  ),
                  const TransactionDetailItem(
                    leftText: 'Comisión',
                    rightText: '\$0.00 MXN',
                  ),
                  const TransactionDetailItem(
                    leftText: 'Tipo de TXN',
                    rightText: 'Depósito',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 64, top: 18),
                    child: Text(
                      'Descargar Detalle de la Actividad',
                      style: TextStyle(
                        color: Color(0xFF4E76E5),
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationThickness: 4,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF4E76E5),
                      ),
                      onPressed: () {},
                      child: Text("Cerrar"),
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
