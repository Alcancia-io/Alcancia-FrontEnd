import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/transaction_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class WithdrawOptionsScreen extends StatelessWidget {
  const WithdrawOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AlcanciaToolbar(
        title: appLoc.labelWithdraw,
        state: StateToolbar.titleIcon,
        logoHeight: 40,
      ),
      body: Column(
        children: [
          TransactionOption(
            imageSrc: "lib/src/resources/images/icon_bank.svg",
            title: appLoc.labelPesosWithdrawals,
            subtitle: appLoc.labelPesosWithdrawalsSubtitle,
            pill1: appLoc.labelUnder20Min,
            onTap: () {
              context.push("/fiat-withdrawal");
            },
          ),
          TransactionOption(
            imageSrc: "lib/src/resources/images/icon_coins.svg",
            title: appLoc.labelCryptoWithdrawals,
            subtitle: appLoc.labelCryptoDepositsSubtitle,
            pill1: appLoc.labelUnder5Min,
            onTap: () {
              context.push("/crypto-withdrawal");
            },
            comingSoon: false,
          )
        ],
      ),
    );
  }
}
