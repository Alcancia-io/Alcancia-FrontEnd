import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/withdraw/withdraw_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  WithdrawScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
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
  final _targetTextController = TextEditingController();

  bool _isLoading = false;
  bool _loadingButton = false;
  String _error = "";
  String _orderError = "";

  double suarmiUSDCExchange = 0;
  double suarmiCELOExchange = 0;
  double targetAmount = 0;

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
    final userBalance = ref.watch(userProvider)!.balance;
    final balance = sourceCurrency == "USDC" ? userBalance.usdcBalance : userBalance.celoBalance;

    if (_isLoading) {
      return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
    }

    if (_error != "") {
      return Scaffold(body: SafeArea(child: Center(child: Text(_error))));
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AlcanciaToolbar(
          title: appLoc.labelMoneyWithdrawal,
          state: StateToolbar.titleIcon,
          logoHeight: 40,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            onChanged: () => setState(() => _enableButton = _formKey.currentState!.validate()),
            child: ListView(
              padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
              children: [
                Text(
                  appLoc.labelHello,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    appLoc.labelWithdrawInformationPrompt,
                    style: txtTheme.bodyText1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLoc.labelCountry,
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
                      appLoc.labelCurrency,
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
                          if (_amountTextController.text.isNotEmpty) {
                            updateTargetAmount(value);
                          }
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
                  labelText: appLoc.labelCLABE,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLoc.errorRequiredField;
                    } else if (value.length != 18) {
                      return appLoc.errorCLABELength;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                LabeledTextFormField(
                  controller: _amountTextController,
                  labelText: appLoc.labelWithdrawAmount,
                  inputType: TextInputType.number,
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLoc.errorRequiredField;
                    } else if (balance < double.parse(value)) {
                      return appLoc.errorInsufficientBalance;
                    }
                    return null;
                  },
                  onChanged: updateTargetAmount,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(appLoc.labelAvailableBalance(balance.toStringAsFixed(2))),
                const SizedBox(
                  height: 10,
                ),
                LabeledTextFormField(
                  controller: _targetTextController,
                  labelText: appLoc.labelAmountMXN,
                  inputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  enabled: false,
                ),
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
                          buttonText: appLoc.buttonNext,
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
                                      "to_currency": "MXN",
                                      "bank_account": _clabeTextController.text,
                                    }
                                  };
                                  try {
                                    final order = await controller.sendSuarmiOrder(orderInput);
                                    context.go("/success", extra: appLoc.labelWithdrawalSent);
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
      ),
    );
  }

  void updateTargetAmount(String value) {
    setState(() {
      targetAmount = value.isNotEmpty
          ? double.parse(_amountTextController.text) /
          (sourceCurrency == "USDC" ? suarmiUSDCExchange : suarmiCELOExchange)
          : 0;
      _targetTextController.text = targetAmount.toStringAsFixed(3);
    });
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}