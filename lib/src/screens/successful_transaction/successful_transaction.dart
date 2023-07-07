import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/extensions/datetime_extensions.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SuccessfulTransaction extends StatelessWidget {
  final TransferResponse transferResponse;

  const SuccessfulTransaction({super.key, required this.transferResponse});

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AlcanciaToolbar(
              state: StateToolbar.titleIcon,
              title: appLoc.confirmation,
              logoHeight: 42,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 44, vertical: 68),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.dark ? alcanciaFieldDark : alcanciaFieldLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50, bottom: 35),
                              child: Center(
                                child: Text(appLoc.successfulTransaction, style: txtTheme.subtitle1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appLoc.sourceAccount, style: txtTheme.subtitle2),
                                  Text(appLoc.labelBalance, style: txtTheme.subtitle2),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appLoc.targetPhone, style: txtTheme.subtitle2),
                                  Text(transferResponse.destPhoneNumber, style: txtTheme.subtitle2),
                                  Text(transferResponse.destUserName, style: txtTheme.subtitle2)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appLoc.transactionDate, style: txtTheme.subtitle2),
                                  Text(transferResponse.txnDate.formattedLocalString(), style: txtTheme.subtitle2)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appLoc.idReference, style: txtTheme.subtitle2),
                                  Text(transferResponse.txnId, style: txtTheme.subtitle2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Transform.translate(
                          offset: const Offset(0, -26),
                          child: SvgPicture.asset('lib/src/resources/images/icon_check.svg'),
                        ),
                      )
                    ],
                  ),
                  // TODO: comment this line since we dont have share feature yet
                  // Container(
                  //   margin: const EdgeInsets.symmetric(vertical: 36),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       SvgPicture.asset('lib/src/resources/images/icon_share.svg'),
                  //       const Padding(
                  //         padding: EdgeInsets.only(left: 8.0),
                  //         child: Text('Compartir'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.only(top: 86),
                    child: AlcanciaButton(
                      height: 64,
                      width: double.infinity,
                      buttonText: appLoc.goBackToMainMenu,
                      onPressed: () => context.go('/'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
