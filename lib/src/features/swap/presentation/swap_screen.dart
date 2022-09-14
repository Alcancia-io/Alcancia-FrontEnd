import 'package:alcancia/src/features/swap/data/exchange_api.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_link.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/services/exchange_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  ExchangeApiService exchangeApiService =
      ExchangeApiService(baseCurrencyCode: "USD");
  late String targetAmount = "";
  final sourceAmountController = TextEditingController();
  final String baseCurrencyCode = "USD";
  final List<Map> targetCurrencyCodes = [
    {"name": "MXN", "icon": "lib/src/resources/images/icon_mexico_flag.svg"},
    {"name": "DOP", "icon": "lib/src/resources/images/icon_mexico_flag.svg"},
  ];
  final List<Map> baseCurrencyCodes = [
    {"name": "USD"},
  ];

  late String sourceDropdownVal = targetCurrencyCodes.first['name'];

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ExchangeApi>(
          future: exchangeApiService.fetchCurrency(sourceDropdownVal),
          builder: (context, snapshot) {
            var conversionRate = snapshot.data?.conversionRate;

            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  const AlcanciaToolbar(
                    state: StateToolbar.logoNoletters,
                    logoHeight: 40,
                  ),

                  // general container, sets padding
                  Container(
                    padding: const EdgeInsets.only(
                      left: 34,
                      right: 34,
                      bottom: 32,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4,
                            bottom: 32,
                          ),
                          child: Text(
                            "Deposita a tu cuenta",
                            style: txtTheme.subtitle1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 32,
                          ),
                          child: Text(
                            "¡Empecemos!",
                            style: txtTheme.headline1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 30,
                          ),
                          child: Text(
                            "Ingresa el monto que deseas convertir de nuestra opciones. A continuación, se presenta a cuanto equivale en",
                            style: txtTheme.bodyText1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? alcanciaCardDark
                                    : alcanciaFieldLight,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "¿Cuánto deseas convertir?",
                                style: txtTheme.bodyText1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AlcanciaDropdown(
                                        dropdownWidth: 120,
                                        dropdownItems: targetCurrencyCodes,
                                        onChanged: (newValue) {
                                          setState(() {
                                            sourceDropdownVal = newValue;
                                            exchangeApiService
                                                .fetchCurrency(newValue);
                                          });
                                        }),
                                    SizedBox(
                                      height: 45,
                                      width: 150,
                                      child: TextField(
                                        style: const TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          fillColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType: TextInputType.number,
                                        controller: sourceAmountController,
                                        onChanged: (text) {
                                          setState(() {
                                            targetAmount = text;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 12, top: 12),
                                child: Center(
                                  child: SvgPicture.asset(
                                      "lib/src/resources/images/arrow_down_purple.svg"),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AlcanciaDropdown(
                                    dropdownWidth: 120,
                                    dropdownItems: baseCurrencyCodes,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    height: 45,
                                    width: 150,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      targetAmount == ""
                                          ? ""
                                          : (int.parse(sourceAmountController
                                                      .text) /
                                                  conversionRate!)
                                              .toStringAsFixed(4),
                                      style: txtTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(
                            top: 32,
                          ),
                          child: Text(
                            "Medio de pago:",
                            style: txtTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 12),
                          child: AlcanciaButton(
                            buttonText: "Tarjeta de Débito/Crédito",
                            onPressed: () {},
                            color: alcanciaLightBlue,
                            width: double.infinity,
                            height: 64,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 12),
                          child: AlcanciaButton(
                            buttonText: "Coinbase",
                            onPressed: () {},
                            color: alcanciaLightBlue,
                            width: double.infinity,
                            height: 64,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("¿Tienes alguna inquietud? "),
                              AlcanciaLink(
                                text: 'Haz click aquí',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
