import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WithdrawScreen extends StatefulWidget {
  WithdrawScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final List<Map> countries = [
    {"name": "México", "icon": "lib/src/resources/images/icon_mexico_flag.png"},
    //{"name": "República Dominicana", "icon": "lib/src/resources/images/icon_dominican_flag.png"},
  ];

  final List<Map> sourceCurrencies = [
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
    {"name": "cUSD", "icon": "lib/src/resources/images/icon_celo_usd.png"},
  ];

  final _clabeTextController = TextEditingController();
  final _amountTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: ListView(
            padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
            children: [
              const AlcanciaToolbar(
                title: "Retiro de dinero",
                state: StateToolbar.titleIcon,
                logoHeight: 40,
              ),
              const Text(
                "!Hola!",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Moneda",
                    style: txtTheme.bodyText1,
                  ),
                  AlcanciaDropdown(
                    itemsAlignment: MainAxisAlignment.start,
                    dropdownItems: sourceCurrencies,
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              LabeledTextFormField(
                controller: _clabeTextController,
                labelText: "Número CLABE",
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLoc.errorRequiredField;
                  } else if (value.length != 18) {
                    return "La CLABE debe consistir de 18 dígitos";
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              LabeledTextFormField(
                controller: _amountTextController,
                labelText: "Monto de retiro",
                inputType: TextInputType.number,
                inputFormatters: [currencyFormatter()],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLoc.errorRequiredField;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextInputFormatter currencyFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String value = newValue.text;
      value = value.replaceAll(',', '').replaceAll('.', '').replaceAll('\$', '');
      if (value.isEmpty) return newValue;
      final numValue = double.parse(value);
      final currencyValue = NumberFormat.currency(symbol: "\$", decimalDigits: 0).format(numValue);
      return TextEditingValue(text: currencyValue, selection: TextSelection.collapsed(offset: currencyValue.length));
    });
  }
}
