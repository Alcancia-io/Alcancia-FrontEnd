import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_copy_clipboard.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:alcancia/src/shared/models/checkout_model.dart';
import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../resources/colors/colors.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key, required this.checkoutData});

  final ResponsiveService responsiveService = ResponsiveService();
  final ExceptionService exceptionService = ExceptionService();

  final SuarmiService suarmiService = SuarmiService();

  final CheckoutModel checkoutData;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appLoc.labelDepositHere,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: OrderInformation(txnInput: checkoutData.txnInput, suarmiConcept: checkoutData.order.concept),
              ),
              AlcanciaButton(
                height: responsiveService.getHeightPixels(64, screenHeight),
                width: double.infinity,
                buttonText: appLoc.buttonDeposited,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    AlcanciaSnackBar(
                      context,
                      appLoc.alertDepositConfirmed,
                    ),
                  );
                  context.go('/');
                },
              )
            ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${bankInfo[key]}', style: textStyle),
                        if (key != "Cuenta") ...[
                          AlcanciaCopyToClipboard(displayText: '$key copiad@', textToCopy: bankInfo[key] as String),
                        ]
                      ],
                    )
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
                      AlcanciaCopyToClipboard(displayText: "Concepto copiad@", textToCopy: suarmiConcept as String),
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
