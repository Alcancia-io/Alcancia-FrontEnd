import 'dart:convert';
import 'dart:developer';

import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../resources/colors/colors.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key, required this.txnInput});

  final TransactionInput txnInput;
  late TransactionMethod txnMethod = txnInput.txnMethod;
  final ResponsiveService responsiveService = ResponsiveService();

  final SuarmiService suarmiService = SuarmiService();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    var orderInput = {
      "orderInput": {
        "from_amount": txnInput.sourceAmount.toString(),
        "type": txnInput.txnType.name.toUpperCase(),
        "from_currency": "MXN",
        "network": "MATIC",
        "to_amount": txnInput.targetAmount.toString(),
        "to_currency": "aPolUSDC"
      }
    };

    print(orderInput);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<QueryResult>(
          future: suarmiService.sendSuarmiOrder(orderInput),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text("${snapshot.error}");
            if (snapshot.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
            var suarmiOrder = SuarmiOrder.fromJson(snapshot.data?.data?["sendSuarmiOrder"]);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Deposita aquí",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: OrderInformation(txnInput: txnInput, suarmiConcept: suarmiOrder.concept),
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
                      context.push('/');
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderInformation extends StatelessWidget {
  OrderInformation({
    super.key,
    required this.txnInput,
    this.suarmiConcept,
  });

  final TransactionInput txnInput;
  final String? suarmiConcept;
  late Map<String, String> bankInfo;

  List<Widget> list = [];

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final total = txnInput.sourceAmount;

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
                    Text('$key:', style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
                    Text('${bankInfo[key]}', style: textStyle),
                  ],
                ),
              )
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Concepto:", style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$suarmiConcept", style: textStyle),
                      InkWell(
                        child: const Icon(Icons.copy, size: 20, color: Colors.blue),
                        onTap: () async {
                          Clipboard.setData(ClipboardData(text: suarmiConcept));
                          ScaffoldMessenger.of(context).showSnackBar(
                            AlcanciaSnackBar(
                              context,
                              "Concepto copiado",
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
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
