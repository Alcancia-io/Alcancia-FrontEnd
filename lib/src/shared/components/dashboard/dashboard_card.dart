import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/dashboard/balance_carousel.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardCard extends ConsumerWidget {
  DashboardCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = Theme.of(context);
    final userBalance = ref.watch(balanceProvider);
    final appLoc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ctx.brightness == Brightness.dark ? alcanciaCardDark2 : alcanciaCardLight2,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BalanceCarousel(balance: userBalance),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AlcanciaButton(
                    buttonText: appLoc.labelDeposit,
                    onPressed: () {
                      context.push("/swap");
                    },
                    width: 116,
                    height: 38,
                    color: alcanciaMidBlue,
                  ),
                  AlcanciaButton(
                    buttonText: appLoc.labelWithdraw,
                    onPressed: () {
                      context.push("/withdraw");
                    },
                    width: 116,
                    height: 38,
                    color: alcanciaMidBlue,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
