import 'dart:developer';

import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:flutter/material.dart';

import 'package:alcancia/src/shared/models/alcancia_models.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key, required this.txnInput});

  final TransactionInput txnInput;
  late TransactionMethod txnMethod = txnInput.txnMethod;

  @override
  Widget build(BuildContext context) {
    inspect(txnInput);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OrderInformation(txnInput: txnInput),
            AlcanciaButton(
              buttonText: "Entendido",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  AlcanciaSnackBar(
                    context,
                    "Gracias! Te notificaremos cuando la transacción sea confirmada",
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class OrderInformation extends StatelessWidget {
  OrderInformation({
    super.key,
    required this.txnInput,
  });

  final TransactionInput txnInput;
  late Map<String, String> bankInfo;

  List<Widget> list = [];

  @override
  Widget build(BuildContext context) {
    var fee = txnInput.txnMethod == TransactionMethod.cryptopay ? 0.01 : 0.02;

    if (txnInput.txnMethod == TransactionMethod.cryptopay) {
      bankInfo = cryptopayInfo;
    } else {
      bankInfo = suarmiInfo;
    }

    return Column(
      children: [
        for (var key in bankInfo.keys) ...[
          Text('$key: ${bankInfo[key]}'),
        ],
        Text("Cantidad: ${txnInput.quantity}"),
        Text("Comisión: $fee"),
        Text("Total: ${txnInput.quantity + (txnInput.quantity * fee)}"),
      ],
    );
  }
}
