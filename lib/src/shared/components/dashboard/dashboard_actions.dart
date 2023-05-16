import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardActions extends StatelessWidget {
  const DashboardActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AlcanciaButton(
              rounded: true,
              icon: SvgPicture.asset("lib/src/resources/images/icon_deposit.svg", color: Colors.white,),
              buttonText: appLoc.labelDeposit,
              foregroundColor: Colors.white,
              onPressed: () {
                context.push("/swap");
              },
              height: 38,
              color: alcanciaMidBlue,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AlcanciaButton(
              rounded: true,
              icon: SvgPicture.asset("lib/src/resources/images/icon_transfer.svg", color: Colors.white,),
              buttonText: appLoc.labelTransfer,
              foregroundColor: Colors.white,
              onPressed: () {
                context.push("/transfer");
              },
              height: 38,
              color: alcanciaMidBlue,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AlcanciaButton(
              rounded: true,
              icon: SvgPicture.asset("lib/src/resources/images/icon_withdraw.svg", color: Colors.white,),
              buttonText: appLoc.labelWithdraw,
              foregroundColor: Colors.white,
              onPressed: () {
                context.push("/withdraw");
              },
              height: 38,
              color: alcanciaMidBlue,
            ),
          ),
        ),
      ],
    );
  }
}
