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
      "icon": "lib/src/resources/images/icon_dominican_flag.png"
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
                      const Text(
                        "Hola!",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          "Completa la siguiente información para realizar el retiro de tu dinero:",
                          style: txtTheme.bodyText1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
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
                      const LabeledTextFormField(
                        controller: null,
                        labelText: "Banco",
                        inputType: TextInputType.name,
                        padding: EdgeInsets.only(bottom: 16, top: 10),
                      ),
                      const LabeledTextFormField(
                        controller: null,
                        labelText: "Número CLABE / Número de cuenta",
                        inputType: TextInputType.name,
                        padding: EdgeInsets.only(bottom: 16),
                      ),
                      const LabeledTextFormField(
                        controller: null,
                        labelText: "INE / Cédula",
                        inputType: TextInputType.name,
                        padding: EdgeInsets.only(bottom: 16),
                      ),
                      const LabeledTextFormField(
                        controller: null,
                        labelText: "Nombre del dueño de la cuenta",
                        inputType: TextInputType.name,
                        padding: EdgeInsets.only(bottom: 16),
                      ),
                      const LabeledTextFormField(
                        controller: null,
                        labelText: "Monto de retiro",
                        inputType: TextInputType.number,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Row(
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
                        ),
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
