import 'dart:convert';
import 'package:alcancia/src/features/swap/data/exchange_api.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_link.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SwapScreen extends StatefulWidget {
  SwapScreen({Key? key}) : super(key: key);

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  String baseCurrency = "USD";

  String targetCurrency = "MXN";

  final sourceAmountController = TextEditingController();

  late String targetAmount = "";

  late String uri =
      "${dotenv.env["EXCHANGE_API_URL"]}pair/$baseCurrency/$targetCurrency";

  Future<ExchangeApi> fetchCurrency(String sourceCurrencyCode) async {
    var baseUrl = dotenv.env["EXCHANGE_API_URL"];
    var apiKey = dotenv.env["EXCHANGE_API_KEY"];
    var exchangeUrl =
        "${baseUrl}${apiKey}pair/${baseCurrency}/${sourceCurrencyCode}";
    final response = await http.get(
      Uri.parse(exchangeUrl),
    );
    if (response.statusCode == 200) {
      return ExchangeApi.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Failed to load exchange api data');
    }
  }

  final List<String> sourceCurrencies = <String>["MXN", "DOP"];
  final List<String> targetCurrencies = <String>["USDC"];
  late String sourceDropdownVal = sourceCurrencies.first;
  late String targetDropdownVal = targetCurrencies.first;

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ExchangeApi>(
          future: fetchCurrency(sourceDropdownVal),
          builder: (context, snapshot) {
            var conversionRate = snapshot.data?.conversionRate;
            // var usdc = int.parse(sourceAmountController.text) / conversionRate;
            // var usdc = conversionRate;

            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              // return Text("${snapshot.data!.conversionRate}");
              return Column(
                children: [
                  Row(
                    children: const [
                      AlcanciaToolbar(
                        state: StateToolbar.logoNoletters,
                        logoHeight: 40,
                      ),
                    ],
                  ),

                  // general container, sets padding
                  Padding(
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
                          decoration: const BoxDecoration(
                            color: Color(0xFF071737),
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          width: 300,
                          height: 200,
                          child: Column(
                            children: [
                              Text(
                                "¿Cuánto deseas convertir?",
                                style: txtTheme.bodyText1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DropdownButton<String>(
                                      value: sourceDropdownVal,
                                      items: sourceCurrencies
                                          .map<DropdownMenuItem<String>>(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          sourceDropdownVal = value!;
                                          fetchCurrency(sourceDropdownVal);
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 45,
                                      width: 170,
                                      child: TextField(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButton<String>(
                                    value: targetDropdownVal,
                                    items: targetCurrencies
                                        .map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {},
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: alcanciaMidBlue,
                                    ),
                                    alignment: Alignment.center,
                                    height: 45,
                                    width: 170,
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
                        Padding(
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
                            width: 304,
                            height: 64,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 12),
                          child: AlcanciaButton(
                            buttonText: "Coinbase",
                            onPressed: () {},
                            color: alcanciaLightBlue,
                            width: 304,
                            height: 64,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
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
