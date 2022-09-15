import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter/material.dart';

class WithdrawScreen extends StatelessWidget {
  WithdrawScreen({Key? key}) : super(key: key);
  final List<Map> countries = [
    {"name": "México", "icon": "lib/src/resources/images/icon_mexico_flag.png"},
    {
      "name": "República Dominicana",
      "icon": "lib/src/resources/images/icon_mexico_flag.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AlcanciaToolbar(
                        title: "Retiro de dinero",
                        state: StateToolbar.titleIcon,
                        logoHeight: 40,
                      ),
                      Text(
                        "Hola!",
                        style: txtTheme.headline1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          "Completa la siguiente información para realizar el retiro de tu dinero:",
                          style: txtTheme.bodyText1,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "País",
                              style: txtTheme.bodyText1,
                            ),
                            AlcanciaDropdown(
                              itemsAlignment: MainAxisAlignment.start,
                              dropdownItems: countries,
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Banco",
                              style: txtTheme.bodyText1,
                            ),
                            Container(
                              height: 45,
                              child: TextField(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Número CLABE / Número de cuenta",
                              style: txtTheme.bodyText1,
                            ),
                            Container(
                              height: 45,
                              child: TextField(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "INE / Cédula",
                              style: txtTheme.bodyText1,
                            ),
                            Container(
                              height: 45,
                              child: TextField(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nombre del dueño de la cuenta",
                              style: txtTheme.bodyText1,
                            ),
                            Container(
                              height: 45,
                              child: TextField(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Monto de retiro",
                              style: txtTheme.bodyText1,
                            ),
                            Container(
                              height: 45,
                              child: TextField(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AlcanciaButton(
                            buttonText: "Siguiente",
                            onPressed: () {},
                            color: alcanciaLightBlue,
                            width: 308,
                            height: 64,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
