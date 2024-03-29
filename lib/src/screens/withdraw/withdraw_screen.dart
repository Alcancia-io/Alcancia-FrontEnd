import 'package:alcancia/firebase_remote_config.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/error/error_screen.dart';
import 'package:alcancia/src/screens/withdraw/withdraw_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/decimal_input_formatter.dart';
import 'package:alcancia/src/shared/models/remote_config_data.dart';
import 'package:alcancia/src/shared/models/success_screen_model.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  final controller = WithdrawController();
  final suarmiService = SwapService();

  /*final List<Map> countries = [
    {"name": "México", "icon": "lib/src/resources/images/icon_mexico_flag.png"},
    {
      "name": "República Dominicana",
      "icon": "lib/src/resources/images/icon_dominican_flag.png"
    },
  ];
  late String country = countries.first['name'];

  final List<Map> sourceCurrenciesMXN = [
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
    /*{"name": "cUSD", "icon": "lib/src/resources/images/icon_celo_usd.png"},*/
  ];
  final List<Map> sourceCurrenciesDOP = [
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
  ];
  final List<Map> dopBanks = [
    {"name": "Banreservas"},
    {"name": "Banco Popular"},
    {"name": "Banco BHD"},
    {"name": "Scotiabank"},
    {"name": "Asociación Popular"},
    {"name": "Banco Santa Cruz"},
    {"name": "Asociación Cibao"},
    {"name": "Banco Promerica"},
    {"name": "Banesco"},
    {"name": "Asociación La Nacional"},
    {"name": "Banco Caribe"},
    {"name": "Citibank"},
    {"name": "Banco BDI"},
    {"name": "Banco López de Haro"},
    {"name": "Banco Ademi"},
    {"name": "Banco Vimenca"},
    {"name": "Bandex"},
    {"name": "Banco Lafise"},
    {"name": "Qik"},
  ];
  

  */
  late List<Map> countries;
  late String country;
  late List<Map> sourceCurrencies;
  late List<Map> listBanks;
  late String selectedBank;
  late String sourceCurrency;
  late RemoteConfigData remoteConfigDataSet;
  late CountryConfig sourceCurrenciesObjt;
  late String sourceMXNCurrency = sourceCurrencies.first['name'];
  late String sourceDOPCurrency = sourceCurrencies.first['name'];

  final _clabeTextController = TextEditingController();
  final _accountTextController = TextEditingController();
  final _amountTextController = TextEditingController();
  final _targetTextController = TextEditingController();
  bool _isLoading = false;
  bool _loadingButton = false;
  String _error = "";
  String _orderError = "";
  late String countryCode = "";
  double suarmiUSDCExchange = 0;
  double suarmiCELOExchange = 0;
  double targetAmount = 0;

  // alcancia exchanges
  var alcanciaUSDCExchange = 1.0;
  late double alcanciaUSDExchange;

  Future<void> getExchange([double? exchangeUSD]) async {
    _isLoading = true;
    try {
      bool isMxEnabled = remoteConfigDataSet.countryConfig.entries
          .firstWhere((e) => e.key == "MX")
          .value
          .enabled;
      var mxnExchangeRate = "0.0";
      var mxnCeloRate = "0.0";
      if (isMxEnabled) {
        mxnExchangeRate =
            await controller.getSuarmiExchange(sourceCurrency: "USDC");
        mxnCeloRate =
            await controller.getSuarmiExchange(sourceCurrency: "cUSD");
      }

      var dopExchangeRate = await controller.getAlcanciaExchange("USDC");
      setState(() {
        suarmiUSDCExchange = 1.0 / double.parse(mxnExchangeRate);
        suarmiCELOExchange = 1.0 / double.parse(mxnCeloRate);
        alcanciaUSDCExchange = 1 / dopExchangeRate;
        if (exchangeUSD != null) {
          alcanciaUSDExchange = exchangeUSD;
        }
      });
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

    final user = ref.read(userProvider);

    remoteConfigDataSet = ref.read(remoteConfigDataStateProvider);
    if (user?.lastUsedBankAccount != null) {
      _clabeTextController.text = user!.lastUsedBankAccount!;
    }

    countries = remoteConfigDataSet.countryConfig.entries
        .where((element) => element.value.enabled == true)
        .map((e) => {"name": getCountryFromCode(e.key), "icon": e.value.icon})
        .toList();
    //Put the User's Country as first on the Countries list
    int currentUserCountryIndex = countries.indexWhere(
        (element) => element['name'] == getCountryFromCode(user!.country));
    if (currentUserCountryIndex != -1) {
      countries.insert(0, countries.removeAt(currentUserCountryIndex));
    }
    country = getCountryFromCode(remoteConfigDataSet.countryConfig.entries
        .firstWhere(
          (e) => e.value.enabled == true && e.key == user!.country,
          orElse: () => remoteConfigDataSet.countryConfig.entries.first,
        )
        .key);
    countryCode = user!.country;

    sourceCurrenciesObjt = remoteConfigDataSet.countryConfig.entries
        .firstWhere(
          (e) => e.key == countryCode && e.value.enabled == true,
          orElse: () => remoteConfigDataSet.countryConfig.entries.first,
        )
        .value;

    sourceCurrencies = sourceCurrenciesObjt.currencies.entries
        .where((element) => element.value.enabled == true)
        .map((e) => {"name": e.key, "icon": e.value.icon})
        .toList();

    listBanks =
        sourceCurrenciesObjt.banksWithdraw!.map((e) => {"name": e}).toList();

    selectedBank = listBanks.first['name'];

    var exchangeUSD = sourceCurrenciesObjt.currencies.entries
        .firstWhere((e) => e.key == "USD")
        .value
        .exchangeRate;
    getExchange(exchangeUSD);
  }

  String getSourceCurrency(String country) {
    if (country == "México") {
      return sourceMXNCurrency;
    } else {
      return sourceDOPCurrency;
    }
  }

  double getExchangeRate(String country) {
    if (country == "México") {
      if (sourceMXNCurrency == "USDC") {
        return suarmiUSDCExchange;
      } else {
        return suarmiCELOExchange;
      }
    } else {
      return alcanciaUSDCExchange;
    }
  }

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    final appLoc = AppLocalizations.of(context)!;
    final userBalance = ref.watch(balanceProvider);

    if (_isLoading) {
      return const Scaffold(
          body: SafeArea(child: Center(child: CircularProgressIndicator())));
    }

    if (_error != "") {
      return const ErrorScreen();
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
            onChanged: () => setState(
                () => _enableButton = _formKey.currentState!.validate()),
            child: ListView(
              padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
              children: [
                Text(
                  appLoc.labelHello,
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w700),
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
                          color:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        onChanged: (value) {
                          setState(() {
                            country = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (country == "México") ...[
                  MXNFields(userBalance.total, context, sourceCurrencies),
                ] else if (country == "República Dominicana") ...[
                  DOPFields(
                      userBalance.total, context, sourceCurrencies, listBanks),
                ],
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
                                  await sendOrder(context, appLoc, country);
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
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _orderError,
                            style: const TextStyle(color: Colors.red),
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

  Future<void> sendOrder(BuildContext context, AppLocalizations appLoc,
      String selectedCountry) async {
    Map<String, dynamic> orderInput = {};
    if (selectedCountry == "México") {
      orderInput = {
        "orderInput": {
          "from_amount": _amountTextController.text,
          "type": "WITHDRAW",
          "from_currency": 'USDC',
          "network": "MATIC",
          "to_amount": targetAmount.toString(),
          "to_currency": sourceMXNCurrency,
          "bank_account": _clabeTextController.text,
        }
      };
    } else {
      orderInput = {
        "orderInput": {
          "from_amount": _amountTextController.text,
          "type": "WITHDRAW",
          "from_currency": 'USDC',
          "network": "ALCANCIA",
          "to_amount": targetAmount.toString(),
          "to_currency": sourceDOPCurrency,
          "bank_account": _accountTextController.text,
          "bank_name": selectedBank,
        }
      };
    }
    try {
      await controller.sendOrder(orderInput);
      context.go("/success",
          extra: SuccessScreenModel(title: appLoc.labelWithdrawalSent));
    } catch (e) {
      setState(() {
        _orderError = e.toString();
      });
    }
  }

  void updateTargetAmount(String value) {
    setState(() {
      if (sourceDOPCurrency == "USD") {
        targetAmount = value.isNotEmpty
            ? double.parse(_amountTextController.text) * alcanciaUSDExchange
            : 0;
      } else {
        targetAmount = value.isNotEmpty
            ? double.parse(_amountTextController.text) /
                getExchangeRate(country)
            : 0;
      }

      _targetTextController.text = targetAmount.toStringAsFixed(3);
    });
  }

  Widget MXNFields(double balance, BuildContext context, List<Map> currencies) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLoc.labelCurrency,
              style: txtTheme.bodyText1,
            ),
            AlcanciaDropdown(
              itemsAlignment: MainAxisAlignment.start,
              dropdownItems: currencies,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(7),
              ),
              onChanged: (value) {
                setState(() {
                  sourceMXNCurrency = value;
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
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        LabeledTextFormField(
          controller: _amountTextController,
          labelText: "${appLoc.labelWithdrawAmount} USDC",
          inputType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLoc.errorRequiredField;
            } else if (double.parse(value) < 10) {
              return appLoc.errorMinimumWithdrawAmount;
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
          labelText: "${appLoc.labelAmount} $sourceMXNCurrency",
          inputType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          enabled: false,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget DOPFields(double balance, BuildContext context, List<Map> currencies,
      List<Map> banks) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  sourceDOPCurrency = value;
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLoc.labelBank,
              style: txtTheme.bodyText1,
            ),
            AlcanciaDropdown(
              itemsAlignment: MainAxisAlignment.start,
              dropdownItems: banks,
              menuMaxHeight: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(7),
              ),
              onChanged: (value) {
                setState(() {
                  selectedBank = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        LabeledTextFormField(
          controller: _accountTextController,
          labelText: appLoc.labelAccountNumber,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          inputType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLoc.errorRequiredField;
            }
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        LabeledTextFormField(
          controller: _amountTextController,
          labelText: "${appLoc.labelWithdrawAmount} USDC",
          inputType: TextInputType.number,
          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLoc.errorRequiredField;
            } else if (double.parse(value) < 10) {
              return appLoc.errorMinimumWithdrawAmount;
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
          labelText: "${appLoc.labelAmount} $sourceDOPCurrency",
          inputType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          enabled: false,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

getCountryFromCode(String key) {
  if (key == "DO") {
    return "República Dominicana";
  } else if (key == "MX") {
    return "México";
  } else {
    return "País no definido";
  }
}
