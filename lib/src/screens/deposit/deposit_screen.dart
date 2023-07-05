import 'package:alcancia/src/screens/deposit/deposit_option.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AlcanciaToolbar(
        title: appLoc.labelDeposit,
        state: StateToolbar.titleIcon,
        logoHeight: 40,
      ),
      body: Column(
        children: [
          DepositOption(
            imageSrc: "lib/src/resources/images/icon_bank.svg",
            title: appLoc.labelPesosDeposits,
            subtitle: appLoc.labelPesosDepositsSubtitle,
            pill1: appLoc.labelNoCommissions,
            pill2: appLoc.labelUnder20Min,
            onTap: () {
              context.push("/swap");
            },
          ),
          DepositOption(
            imageSrc: "lib/src/resources/images/icon_coins.svg",
            title: appLoc.labelCryptoDeposits,
            subtitle: appLoc.labelCryptoDepositsSubtitle,
            pill1: appLoc.labelNoCommissions,
            pill2: appLoc.labelUnder5Min,
            onTap: () {
              context.push("/crypto-deposit");
            },
            comingSoon: true,
          )
        ],
      ),
    );
  }
}
