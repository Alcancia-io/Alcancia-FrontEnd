import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/models/minimal_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../resources/colors/colors.dart';

class AlcanciaConfirmationDialog extends StatelessWidget {
  const AlcanciaConfirmationDialog(
      {super.key,
      required this.targetUser,
      required this.userBalance,
      required this.amount,
      required this.currency,
      required this.onConfirm});

  final MinimalUser targetUser;
  final double userBalance;
  final double amount;
  final String currency;

  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? alcanciaFieldDark : alcanciaFieldLight,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Text(
                appLoc.isDataCorrect,
                style: txtTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLoc.sourceAccount, style: txtTheme.subtitle2),
                        Text('Balance - ${userBalance.toStringAsFixed(2)} $currency',
                            style: txtTheme.subtitle2),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLoc.targetPhone, style: txtTheme.subtitle2),
                        Text(targetUser.phoneNumber, style: txtTheme.subtitle2),
                        Text(targetUser.name, style: txtTheme.subtitle2),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLoc.amount, style: txtTheme.subtitle2),
                        Text('${amount.toStringAsFixed(2)} $currency', style: txtTheme.subtitle2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AlcanciaButton(
              width: double.infinity,
              height: 64,
              buttonText: appLoc.buttonConfirm,
              onPressed: onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
