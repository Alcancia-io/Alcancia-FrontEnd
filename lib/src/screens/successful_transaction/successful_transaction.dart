import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/colors/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuccessfulTransaction extends StatelessWidget {
  const SuccessfulTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AlcanciaToolbar(
              state: StateToolbar.titleIcon,
              title: 'Confirmación',
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? alcanciaFieldDark
                                    : alcanciaFieldLight,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 50, bottom: 35),
                              child: Center(
                                child: Text('!Transferencia exitosa!!', style: txtTheme.subtitle1),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cuenta de origen', style: txtTheme.subtitle2),
                                  Text('Balance', style: txtTheme.subtitle2),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Celular destino', style: txtTheme.subtitle2),
                                  Text('+52 4651075213', style: txtTheme.subtitle2),
                                  Text('David Lerma', style: txtTheme.subtitle2)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Fecha y hora de transacción', style: txtTheme.subtitle2),
                                  Text('Mayo 2, 2023 14:30:00', style: txtTheme.subtitle2)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Id Referencia', style: txtTheme.subtitle2),
                                  Text('ALC123456789', style: txtTheme.subtitle2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Transform.translate(
                          offset: Offset(0, -26),
                          child: SvgPicture.asset('lib/src/resources/images/icon_check.svg')
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('lib/src/resources/images/icon_share.svg'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('Compartir'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: AlcanciaButton(
                      height: 64,
                      width: double.infinity,
                      buttonText: 'Volver al menu principal',
                      onPressed: () {},
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
