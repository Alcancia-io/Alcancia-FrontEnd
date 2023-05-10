import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../resources/colors/colors.dart';

class AlcanciaConfirmationDialog extends StatelessWidget {
  const AlcanciaConfirmationDialog({super.key});

  final balanceAmount = 'Balance - 20.00 USDC';
  final phone = '+52 465 107 5213';
  final name = 'David Lerma';
  final amount = '15 usdc';

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
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
                          Text(balanceAmount, style: txtTheme.subtitle2),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appLoc.targetPhone, style: txtTheme.subtitle2),
                          Text(phone, style: txtTheme.subtitle2),
                          Text(name, style: txtTheme.subtitle2),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appLoc.amount, style: txtTheme.subtitle2),
                          Text(amount, style: txtTheme.subtitle2),
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
      ),
    );
  }
}
