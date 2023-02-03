import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/withdraw/withdraw_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class WithdrawScreen extends StatefulWidget {
  WithdrawScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final controller = WithdrawController();
  final suarmiService = SuarmiService();

  final List<Map> countries = [
    {"name": "México", "icon": "lib/src/resources/images/icon_mexico_flag.png"},
    //{"name": "República Dominicana", "icon": "lib/src/resources/images/icon_dominican_flag.png"},
  ];

  final List<Map> sourceCurrencies = [
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
    {"name": "cUSD", "icon": "lib/src/resources/images/icon_celo_usd.png"},
  ];
  late String sourceCurrency = sourceCurrencies.first['name'];

  final _clabeTextController = TextEditingController();
  final _amountTextController = TextEditingController();

  bool _isLoading = false;
  bool _loadingButton = false;
  String _error = "";
  String _orderError = "";

  double suarmiUSDCExchange = 0;
  double suarmiCELOExchange = 0;

  Future<void> getExchange() async {
    _isLoading = true;
    try {
      var usdcRate = await controller.getSuarmiExchange(sourceCurrency: "USDC");
      var celoRate = await controller.getSuarmiExchange(sourceCurrency: "cUSD");
      suarmiUSDCExchange = 1.0 / double.parse(usdcRate);
      suarmiCELOExchange = 1.0 / double.parse(celoRate);
    } catch (e) {
      _error = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool _enableButton = false;

  @override
  void initState() {
    super.initState();
    getExchange();
  }

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    final appLoc = AppLocalizations.of(context)!;
    final targetAmount = _amountTextController.text.isEmpty
        ? 0
        : double.parse(_amountTextController.text) /
            (sourceCurrency == "USDC" ? suarmiUSDCExchange : suarmiCELOExchange);

    if (_isLoading) {
      return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
    }

    if (_error != "") {
      return Scaffold(body: SafeArea(child: Center(child: Text(_error))));
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          onChanged: () => setState(() => _enableButton = _formKey.currentState!.validate()),
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
              const SizedBox(
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
                    onChanged: (value) {
                      setState(() {
                        sourceCurrency = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
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
              const SizedBox(
                height: 10,
              ),
              LabeledTextFormField(
                controller: _amountTextController,
                labelText: "Monto de retiro",
                inputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLoc.errorRequiredField;
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_amountTextController.text.isNotEmpty) ...[
                Text("Monto en MXN: \$$targetAmount"),
              ],
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_loadingButton) ...[
                      const CircularProgressIndicator(),
                    ] else ...[
                      AlcanciaButton(
                        buttonText: "Siguiente",
                        onPressed: _enableButton
                            ? () async {
                                setState(() {
                                  _loadingButton = true;
                                });
                                final orderInput = {
                                  "orderInput": {
                                    "from_amount": _amountTextController.text,
                                    "type": "WITHDRAW",
                                    "from_currency": sourceCurrency == 'USDC' ? 'aPolUSDC' : 'mcUSD',
                                    "network": sourceCurrency == "USDC" ? "MATIC" : "CELO",
                                    "to_amount": targetAmount.toString(),
                                    "to_currency": "MXN"
                                  }
                                };
                                try {
                                  final order = await controller.sendSuarmiOrder(orderInput);
                                  context.go("/success", extra: "Orden de retiro abierta");
                                } catch (e) {
                                  setState(() {
                                    _orderError = e.toString();
                                  });
                                }
                                setState(() {
                                  _loadingButton = false;
                                });
                              }
                            : null,
                        color: alcanciaLightBlue,
                        width: 308,
                        height: 64,
                      ),
                    ],
                    if (_orderError.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          _orderError,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
