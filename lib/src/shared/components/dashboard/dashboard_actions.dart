import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/dashboard/dashboard_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/models/kyc_status.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardActions extends ConsumerWidget {
  DashboardActions({Key? key}) : super(key: key);

  final DashboardController dashboardController = DashboardController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final appLoc = AppLocalizations.of(context)!;
    switch (user!.kycStatus) {
      case KYCStatus.verified:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AlcanciaButton(
                  rounded: true,
                  icon: SvgPicture.asset(
                    "lib/src/resources/images/icon_deposit.svg",
                    color: Colors.white,
                  ),
                  buttonText: appLoc.labelDeposit,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    context.push("/deposit");
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
                  icon: SvgPicture.asset(
                    "lib/src/resources/images/icon_transfer.svg",
                    color: Colors.white,
                  ),
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
                  icon: SvgPicture.asset(
                    "lib/src/resources/images/icon_withdraw.svg",
                    color: Colors.white,
                  ),
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
      case KYCStatus.pending:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: AlcanciaButton(
            rounded: true,
            buttonText: appLoc.buttonPending,
            icon: Icon(
              CupertinoIcons.hourglass,
              size: 21,
            ),
            foregroundColor: Colors.white,
            onPressed: () {
              Fluttertoast.showToast(
                msg: appLoc.alertVerificationInProcess,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
              );
            },
            height: 38,
            color: Colors.grey,
          ),
        );
      case KYCStatus.failed:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: AlcanciaButton(
            rounded: true,
            icon: Icon(CupertinoIcons.exclamationmark_circle_fill),
            buttonText: appLoc.buttonFailed,
            foregroundColor: Colors.white,
            onPressed: () async {
              if (user.address == null || user.profession == null) {
                context.pushNamed("user-address", extra: {"verified": false});
              } else {
                try {
                  final updatedUser =
                      await dashboardController.verifyUser(user, appLoc);
                  ref.read(userProvider.notifier).setUser(updatedUser);
                  context.go("/");
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: e.toString(),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: alcanciaMidBlue,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              }
            },
            height: 38,
            color: Colors.red,
          ),
        );
      case KYCStatus.none:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: AlcanciaButton(
            rounded: true,
            icon: const Icon(
                CupertinoIcons.person_crop_circle_fill_badge_checkmark),
            buttonText: appLoc.buttonVerifyNow,
            foregroundColor: Colors.white,
            onPressed: () async {
              if ((user.address == null || user.profession == null) &&
                  user.country == 'MX') {
                context.pushNamed("user-address", extra: {"verified": false});
              } else {
                try {
                  final updatedUser =
                      await dashboardController.verifyUser(user, appLoc);
                  ref.read(userProvider.notifier).setUser(updatedUser);
                  context.go("/");
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: e.toString(),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: alcanciaMidBlue,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              }
            },
            height: 38,
            color: alcanciaMidBlue,
          ),
        );
    }
  }
}
