import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../resources/colors/colors.dart';

class AlcanciaConfirmationDialog extends StatelessWidget {
  const AlcanciaConfirmationDialog({super.key, required this.targetUser, required this.userBalance, required this.amount});

  final User targetUser;
  final double userBalance;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;

    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).brightness == Brightness.dark
              ? alcanciaFieldDark
              : alcanciaFieldLight,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        height: 437,
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 44,
          right: 36,
          bottom: 30,
          left: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 36),
              child: Text(
                appLoc.isDataCorrect,
                style: txtTheme.subtitle1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLoc.sourceAccount, style: txtTheme.subtitle2),
                        Text('Balance - ${userBalance.toStringAsFixed(2)}', style: txtTheme.subtitle2),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
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
                    padding: EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLoc.amount, style: txtTheme.subtitle2),
                        Text(amount.toString(), style: txtTheme.subtitle2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AlcanciaButton(
                width: double.infinity,
                height: 64,
                buttonText: 'Si transferir',
                onPressed: (){
                  context.pushNamed('successful-transaction');
                }
            ),
          ],
        ),
      ),
    );
  }
}
