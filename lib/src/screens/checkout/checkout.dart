import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_copy_clipboard.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/components/deposit_info_item.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:alcancia/src/shared/models/bank_info_item.dart';
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
                    txnInput: checkoutData.txnInput,
                    concept: (checkoutData.order.concept == null)
                        ? ""
                        : checkoutData.order.concept!,
                    bankInfo: checkoutData.bank),
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
                  context.go('/homescreen/0');
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
    this.bankInfo,
  });
  final Map<String, String>? bankInfo;
  final TransactionInput txnInput;
  String concept;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final total = txnInput.sourceAmount;

    /*if (txnInput.txnMethod == TransactionMethod.alcancia) {
      bankInfo = AccountInfo.DOPInfo;
    } else {
      bankInfo = AccountInfo.MXNInfo;
    }*/ //Deleted since remote config

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DepositInfoItem(
                  title: appLoc.labelBank,
                  subtitle: bankInfo!["name"].toString(),
                  padding: const EdgeInsets.only(bottom: 18),
                ),
                DepositInfoItem(
                  title: appLoc.labelBeneficiary,
                  subtitle: bankInfo!["info1"].toString(),
                  supportsClipboard: true,
                  padding: const EdgeInsets.only(bottom: 18),
                ),
                if (bankInfo?["info2"] != null) ...[
                  DepositInfoItem(
                    title: appLoc.labelRNC,
                    subtitle: bankInfo!["info2"].toString(),
                    supportsClipboard: true,
                    padding: const EdgeInsets.only(bottom: 18),
                  ),
                ],
                if (bankInfo?["info3"] != null) ...[
                  DepositInfoItem(
                    title: appLoc.labelAccountNumber,
                    subtitle: bankInfo!["info3"].toString(),
                    supportsClipboard: true,
                    padding: const EdgeInsets.only(bottom: 18),
                  ),
                ],
                if (bankInfo?["info4"] != null) ...[
                  DepositInfoItem(
                    title: appLoc.labelAccountType,
                    subtitle: bankInfo!["info4"].toString(),
                    supportsClipboard: true,
                    padding: EdgeInsets.only(bottom: 18),
                  ),
                ],
                if (bankInfo?["CLABE"] != null) ...[
                  DepositInfoItem(
                    title: appLoc.labelCLABE,
                    subtitle: bankInfo!["CLABE"].toString()!,
                    supportsClipboard: true,
                    padding: const EdgeInsets.only(bottom: 18),
                  ),
                ],
                DepositInfoItem(
                  title: appLoc.labelConcept,
                  subtitle: concept,
                  supportsClipboard: true,
                  padding: EdgeInsets.only(bottom: 18),
                ),
              ],
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
