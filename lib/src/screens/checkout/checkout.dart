import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_copy_clipboard.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:alcancia/src/shared/models/checkout_model.dart';
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

  final SwapService suarmiService = SwapService();

  final CheckoutModel checkoutData;

  String get concept {
    if (checkoutData.txnInput.txnMethod == TransactionMethod.suarmi) {
      return checkoutData.txnInput.concept!;
    } else {
      final uuid = checkoutData.order.uuid;
      final concept = uuid.split('-')[4].substring(0, 7);
      return concept;
    }
  }

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
                child: OrderInformation(
                    txnInput: checkoutData.txnInput, concept: concept),
              ),
              AlcanciaButton(
                height: responsiveService.getHeightPixels(64, screenHeight),
                width: double.infinity,
                buttonText: appLoc.buttonDeposited,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    alcanciaSnackBar(
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
    required this.concept,
  });

  final TransactionInput txnInput;
  final String concept;
  late List<BankInfoItem> bankInfo;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final total = txnInput.sourceAmount;

    if (txnInput.txnMethod == TransactionMethod.alcancia) {
      bankInfo = BankInfoItem.DOPInfo;
    } else {
      bankInfo = BankInfoItem.MXNInfo;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? alcanciaCardDark
            : alcanciaFieldLight,
        borderRadius: const BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var item in bankInfo) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.label}:',
                        style:
                            textStyle?.copyWith(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.value}', style: textStyle),
                        if (item.copyable) ...[
                          AlcanciaCopyToClipboard(
                              displayText: '${item.label} copiad@',
                              textToCopy: item.value as String),
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
                  Text(txnInput.txnMethod == TransactionMethod.suarmi ? "Concepto:" : "Comentario/Detalle:",
                      style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(concept, style: textStyle),
                      AlcanciaCopyToClipboard(
                          displayText: "Concepto copiad@",
                          textToCopy: concept as String),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\nTotal:",
                    style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
                Text("\n\$ $total", style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BankInfoItem {
  final String label;
  final String value;
  final bool copyable;

  BankInfoItem({required this.label, required this.value, required this.copyable});

  static List<BankInfoItem> DOPInfo = [
    BankInfoItem(label: "Banco", value: "Banreservas", copyable: false),
    BankInfoItem(label: "Beneficiario", value: "BAPLTECH SRL", copyable: false),
    BankInfoItem(label: "RNC", value: "1-32-75385-2", copyable: true),
    BankInfoItem(label: "No. de cuenta", value: "9605734495", copyable: true),
  ];

  static List<BankInfoItem> MXNInfo = [
    BankInfoItem(label: "Cuenta", value: "Sistema de Transferencias y Pagos (STP)", copyable: false),
    BankInfoItem(label: "Beneficiario", value: "Bctech Solutions SAPI de CV", copyable: true),
    BankInfoItem(label: "CLABE", value: "646180204200011681", copyable: true)
  ];
}
