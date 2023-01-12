import 'dart:developer';

import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';

import '../../resources/colors/colors.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key, required this.txnInput});

  final TransactionInput txnInput;
  late TransactionMethod txnMethod = txnInput.txnMethod;
  final ResponsiveService responsiveService = ResponsiveService();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    inspect(txnInput);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Deposita aquí", style: Theme.of(context).textTheme.displayMedium,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: OrderInformation(txnInput: txnInput),
                ),
                AlcanciaButton(
                  height: responsiveService.getHeightPixels(64, screenHeight),
                  width: double.infinity,
                  buttonText: "¡Ya deposité!",
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
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    var fee = txnInput.txnMethod == TransactionMethod.cryptopay ? cryptopayFee : suarmiFee;
    final total = txnInput.quantity + (txnInput.quantity * (fee/100));
    if (txnInput.txnMethod == TransactionMethod.cryptopay) {
      bankInfo = cryptopayInfo;
    } else {
      bankInfo = suarmiInfo;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? alcanciaCardDark : alcanciaFieldLight,
        borderRadius: const BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var key in bankInfo.keys) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$key:', style: textStyle?.copyWith(fontWeight: FontWeight.bold),),
                    Text('${bankInfo[key]}', style: textStyle),
                  ],
                ),
              )
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Cantidad:", style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
                Text("${txnInput.quantity}", style: textStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Comisión:", style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
                Text("$fee %", style: textStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\nTotal:", style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
                Text("\n\$ $total", style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
