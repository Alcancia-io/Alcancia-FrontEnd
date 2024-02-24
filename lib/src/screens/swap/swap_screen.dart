import 'dart:ffi';

import 'package:alcancia/firebase_remote_config.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/error/error_screen.dart';
import 'package:alcancia/src/screens/investment_info/investment_info.dart';
import 'package:alcancia/src/screens/swap/components/currency_risk_card.dart';
import 'package:alcancia/src/screens/swap/swap_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_container.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/constants.dart';
import 'package:alcancia/src/shared/extensions/type_extensions.dart';
import 'package:alcancia/src/shared/models/checkout_model.dart';
import 'package:alcancia/src/shared/models/kyc_status.dart';
import 'package:alcancia/src/shared/models/remote_config_data.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:alcancia/src/shared/provider/user_provider.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/metamap_service.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SwapScreen extends ConsumerStatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends ConsumerState<SwapScreen> {
  // source amount vars
  final sourceAmountController = TextEditingController();
  final targetAmountController = TextEditingController();

  final minMXNAmount = 200;
  final maxMXNAmount = 50000;
  final minDOPAmount = 1;
  final maxDOPAmount = 150000;

  // source amount icons
  List<Map> sourceCurrencyCodes = [
    //{"name": "MXN", "icon": "lib/src/resources/images/icon_mexico_flag.png"},
    {"name": "DOP", "icon": "lib/src/resources/images/icon_dominican_flag.png"},
  ];

  // target amount icons
  final List<Map> targetMXNCurrencies = [
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
    //{"name": "CUSD", "icon": "lib/src/resources/images/icon_celo_usd.png"},
  ];

  final List<Map> targetDOPCurrencies = [
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
  ];

  // dropdown value for target currency, it can be CUSD or USDC
  late String targetCurrency = targetMXNCurrencies.first['name'];

  // dropdown value for source currency, it can be MXN or DOP
  late String sourceCurrency;
  final ResponsiveService responsiveService = ResponsiveService();

  final SwapController swapController = SwapController();

  // suarmi exchanges
  var suarmiUSDCExchage = 1.0;
  var suarmiCeloExchange = 1.0;

  // alcancia exchange
  var alcanciaUSDCExchange = 1.0;
  var alcanciaUSDtoUSDCRate = 1.0;

  late MapEntry<String, CountryConfig> remoteConfigCountry;
  // state
  bool _isLoading = false;
  bool _loadingCheckout = false;
  String _error = "";

  // Anual Percentage Yields
  String currentCeloAPY = "";
  String? celoAPYError;

  String currentUsdcAPY = "";
  String? usdcAPYError;

  getExchange() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var remoteConfigData = ref.read(remoteConfigDataStateProvider);
      bool isMxEnabled = remoteConfigData.countryConfig.entries
          .firstWhere(((element) => element.key == "MX"))
          .value
          .enabled;

      var mxnExchangeRate = "";
      var mxnCeloRate = "";
      if (isMxEnabled) {
        mxnExchangeRate = await swapController.getSuarmiExchange("USDC");
        mxnCeloRate = await swapController.getSuarmiExchange("cUSD");
      }

      var dopExchangeRate = await swapController.getAlcanciaExchange("USDC");
      setState(() {
        suarmiUSDCExchage = 1.0 / double.parse(mxnExchangeRate);
        suarmiCeloExchange = 1.0 / double.parse(mxnCeloRate);
        alcanciaUSDCExchange = dopExchangeRate;
      });
    } catch (err) {
      // print(err);
      _error = err.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  getCeloAPY() async {
    try {
      var currentCeloAPYResponse = await swapController.getCurrentAPY("mcUSD");
      setState(() {
        currentCeloAPY = currentCeloAPYResponse;
      });
    } on CustomException catch (err) {
      celoAPYError = err.message;
    }
  }

  getUsdcAPY() async {
    try {
      var currentUsdcAPYResponse =
          await swapController.getCurrentAPY("aPolUSDC");
      setState(() {
        currentUsdcAPY = currentUsdcAPYResponse;
      });
    } on CustomException catch (err) {
      usdcAPYError = err.message;
    }
  }

  String calculateTargetAmount(
      String sourceAmount, String targetCurrency, String sourceCurrency) {
    double targetAmount = 0.0;
    if (sourceCurrency == "DOP") {
      targetAmount = double.parse(sourceAmount) / alcanciaUSDCExchange;
    } else if (sourceCurrency == "USD") {
      targetAmount = double.parse(sourceAmount) * alcanciaUSDtoUSDCRate;
    } else {
      targetAmount = double.parse(sourceAmount) /
          (targetCurrency == "USDC" ? suarmiUSDCExchage : suarmiCeloExchange);
    }
    return targetAmount.formatQuantity(4);
  }

  String calculateSourceAmount(
      String targetAmount, String targetCurrency, String sourceCurrency) {
    double sourceAmount = 0.0;
    if (sourceCurrency == "DOP") {
      sourceAmount = double.parse(targetAmount) * alcanciaUSDCExchange;
    } else if (sourceCurrency == "USD") {
      sourceAmount = double.parse(targetAmount) +
          double.parse(targetAmount) * (1 - alcanciaUSDtoUSDCRate);
    } else {
      sourceAmount = double.parse(targetAmount) *
          (targetCurrency == "USDC" ? suarmiUSDCExchage : suarmiCeloExchange);
    }
    return sourceAmount.formatQuantity(4);
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    if (user?.country == "MX") {
      // TEMPORARY DISABLE MXN
      sourceCurrency = "MXN";
    } else if (user?.country == "DO") {
      // TEMPORARY DISABLE MXN
      sourceCurrency = "DOP";
    } else {}
    getExchange();
    getCeloAPY();
    getUsdcAPY();
    final remoteConfigData = ref.read(remoteConfigDataStateProvider);
    remoteConfigCountry = remoteConfigData.countryConfig.entries.firstWhere(
      (e) => e.key == user!.country && e.value.enabled == true,
      orElse: () => MapEntry(
          '',
          CountryConfig(
              icon: '',
              enabled: false,
              currencies: {},
              cryptoCurrencies: {},
              banksWithdraw: null)),
    );
    sourceCurrencyCodes = remoteConfigCountry.value.currencies.entries
        .where((element) => element.value.enabled == true)
        .map((e) => {"name": e.key, "icon": e.value.icon})
        .toList();
    if (sourceCurrencyCodes.length > 1) {
      final sourceCurrencyIndex = sourceCurrencyCodes
          .indexWhere((element) => element['name'] == sourceCurrency);
      final code = sourceCurrencyCodes.removeAt(sourceCurrencyIndex);
      sourceCurrencyCodes.insert(0, code);
    }
    sourceCurrency = sourceCurrencyCodes.first['name'];
    getCurrencyRate();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var remoteConfigData =
        ref.watch(remoteConfigDataStateProvider.notifier).state;
    // investment info
    final usdcInfo = [
      {"bold": appLoc.labelUsdcAsset, "regular": appLoc.descriptionUsdcAsset},
      //{"bold": appLoc.labelAave, "regular": appLoc.descriptionUsdcProtocol}
    ];
    final celoInfo = [
      {"bold": appLoc.labelCeloDollar, "regular": appLoc.descriptionCeloAsset},
      {
        "bold": appLoc.labelMoolaMarket,
        "regular": appLoc.descriptionCeloProtocol
      }
    ];

    if (_isLoading) {
      return const Scaffold(
          body: SafeArea(child: Center(child: CircularProgressIndicator())));
    }

    if (_error != "") return const ErrorScreen();

    Color cardColor = Theme.of(context).brightness == Brightness.dark
        ? alcanciaCardDark
        : alcanciaFieldLight;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AlcanciaToolbar(
          showBackButton: true,
          state: StateToolbar.logoNoletters,
          logoHeight: responsiveService.getHeightPixels(40, screenHeight),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // general container, sets padding
                AlcanciaContainer(
                  top: 20,
                  left: 30,
                  right: 30,
                  bottom: 34,
                  child: Column(
                    children: [
                      AlcanciaContainer(
                        top: 4,
                        bottom: 32,
                        child: Text(appLoc.labelDepositToYourAccount,
                            style: txtTheme.subtitle1),
                      ),
                      AlcanciaContainer(
                        bottom: 32,
                        child: Text(appLoc.labelLetsStart,
                            style: txtTheme.headline1),
                      ),
                      AlcanciaContainer(
                        bottom: 30,
                        child: Text(
                          appLoc.labelInputAmount,
                          style: txtTheme.bodyText1,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: responsiveService.getHeightPixels(
                              20, screenHeight),
                          bottom: responsiveService.getHeightPixels(
                              20, screenHeight),
                          left:
                              responsiveService.getWidthPixels(12, screenWidth),
                          right:
                              responsiveService.getWidthPixels(12, screenWidth),
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appLoc.labelAmountQuestion,
                                style: txtTheme.bodyText1),
                            AlcanciaContainer(
                              top: 8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AlcanciaDropdown(
                                    dropdownWidth: responsiveService
                                        .getWidthPixels(150, screenWidth),
                                    dropdownHeight: responsiveService
                                        .getHeightPixels(45, screenHeight),
                                    dropdownItems: sourceCurrencyCodes,
                                    onChanged: (newValue) {
                                      setState(() {
                                        sourceCurrency = newValue;
                                        getCurrencyRate();
                                        sourceAmountController.text =
                                            calculateSourceAmount(
                                                targetAmountController.text,
                                                targetCurrency,
                                                sourceCurrency);
                                        // when this components intis, we will exchange rate from suarmi and cryptopay
                                      });
                                    },
                                  ),
                                  // this is the input field where user enters source amount
                                  AlcanciaContainer(
                                    height: responsiveService.getHeightPixels(
                                        45, screenHeight),
                                    width: responsiveService.getWidthPixels(
                                        150, screenWidth),
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
                                          if (text.isEmpty) {
                                            targetAmountController.text = "";
                                          } else {
                                            targetAmountController.text =
                                                calculateTargetAmount(
                                                    text,
                                                    targetCurrency,
                                                    sourceCurrency);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Center(
                                child: SvgPicture.asset(
                                  "lib/src/resources/images/arrow_down_purple.svg",
                                  height: 30,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AlcanciaDropdown(
                                  dropdownWidth: responsiveService
                                      .getWidthPixels(150, screenWidth),
                                  dropdownHeight: responsiveService
                                      .getHeightPixels(45, screenHeight),
                                  dropdownItems: sourceCurrency == "MXN"
                                      ? targetMXNCurrencies
                                      : targetDOPCurrencies,
                                  onChanged: (newTargetCurrency) {
                                    setState(() {
                                      getCurrencyRate();
                                      targetCurrency = newTargetCurrency;
                                    });
                                  },
                                ),
                                // here is where target amount is display
                                AlcanciaContainer(
                                  height: responsiveService.getHeightPixels(
                                      45, screenHeight),
                                  width: responsiveService.getWidthPixels(
                                      150, screenWidth),
                                  child: TextField(
                                    style: const TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                      fillColor: Theme.of(context).primaryColor,
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: targetAmountController,
                                    onChanged: (text) {
                                      setState(() {
                                        if (text.isEmpty) {
                                          sourceAmountController.text = "";
                                        } else {
                                          sourceAmountController.text =
                                              calculateSourceAmount(
                                                  text,
                                                  targetCurrency,
                                                  sourceCurrency);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                generateCurrency(
                                    sourceCurrency,
                                    suarmiUSDCExchage,
                                    alcanciaUSDCExchange,
                                    alcanciaUSDtoUSDCRate),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*if (celoAPYError != null) ...[
                        Text(celoAPYError as String)
                      ] else if (targetCurrency == "CUSD") ...[
                        AlcanciaContainer(
                          top: 16,
                          child: CurrencyRiskCard(
                            riskLevel: RiskLevel.medium,
                            targetCurrency: "CUSD",
                            percentage: currentCeloAPY,
                            color: cardColor,
                          ),
                        ),
                      ],
                      if (usdcAPYError != null) ...[
                        Text(usdcAPYError as String)
                      ] else if (targetCurrency == "USDC") ...[
                        AlcanciaContainer(
                          top: 16,
                          child: CurrencyRiskCard(
                            riskLevel: RiskLevel.low,
                            targetCurrency: "USDC",
                            percentage: currentUsdcAPY,
                            color: cardColor,
                          ),
                        ),
                      ],*/ //Comentado por cambio recomendacions SIB
                      AlcanciaContainer(
                        top: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: alcanciaLightBlue),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                icon: SvgPicture.asset(
                                  "lib/src/resources/images/icon_lamp.svg",
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : null,
                                ),
                                label: Text(
                                  appLoc.buttonWhatAmIInvesting,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: txtTheme.bodyText2?.color,
                                    fontSize: txtTheme.bodyText2?.fontSize,
                                  ),
                                ),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return targetCurrency == 'USDC'
                                          ? InvestmentInfo(items: usdcInfo)
                                          : InvestmentInfo(items: celoInfo);
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(
                          top: 32,
                        ),
                        child: Text(
                          appLoc.labelPaymentMethod,
                          style: txtTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 12),
                        child: _loadingCheckout
                            ? const CircularProgressIndicator()
                            : AlcanciaButton(
                                buttonText: appLoc.buttonTransfer,
                                onPressed: _enableButton
                                    ? () async {
                                        Map<String, dynamic> orderInput = {};
                                        TransactionInput? txnInput;

                                        if (sourceCurrency == 'MXN') {
                                          txnInput = TransactionInput(
                                            txnMethod: TransactionMethod.suarmi,
                                            txnType: TransactionType.deposit,
                                            sourceAmount: double.parse(
                                                sourceAmountController.text),
                                            targetAmount: double.parse(
                                                targetAmountController.text),
                                            targetCurrency:
                                                targetCurrency == 'USDC'
                                                    ? 'USDC'
                                                    : 'mcUSD',
                                            network: targetCurrency == 'USDC'
                                                ? 'MATIC'
                                                : 'CELO',
                                          );
                                          Map wrapper = {
                                            "verified": true,
                                            "txnInput": txnInput,
                                          };
                                          if (user!.address == null ||
                                              user.profession == null) {
                                            context.pushNamed('user-address',
                                                extra: wrapper);
                                          } else {
                                            orderInput = {
                                              "orderInput": {
                                                "from_amount": txnInput
                                                    .sourceAmount
                                                    .toString(),
                                                "type": txnInput.txnType.name
                                                    .toUpperCase(),
                                                "from_currency": sourceCurrency,
                                                "network": txnInput.network,
                                                "to_amount": txnInput
                                                    .targetAmount
                                                    .toString(),
                                                "to_currency":
                                                    txnInput.targetCurrency
                                              }
                                            };
                                          }
                                        } else if (sourceCurrency == "DOP" ||
                                            sourceCurrency == "USD") {
                                          txnInput = TransactionInput(
                                            txnMethod:
                                                TransactionMethod.alcancia,
                                            txnType: TransactionType.deposit,
                                            sourceAmount: double.parse(
                                                sourceAmountController.text),
                                            targetAmount: (sourceCurrency ==
                                                    "USD"
                                                ? (double.parse(
                                                        sourceAmountController
                                                            .text) *
                                                    alcanciaUSDtoUSDCRate) //TODO: CHANGE TO REMOTE CONFIG VALUE
                                                : (double.parse(
                                                        sourceAmountController
                                                            .text) /
                                                    alcanciaUSDCExchange)),
                                            targetCurrency:
                                                targetCurrency == 'USDC'
                                                    ? 'USDC'
                                                    : 'mcUSD',
                                            network: 'ALCANCIA',
                                          );
                                          orderInput = {
                                            "orderInput": {
                                              "from_amount": txnInput
                                                  .sourceAmount
                                                  .toString(),
                                              "type": txnInput.txnType.name
                                                  .toUpperCase(),
                                              "from_currency": sourceCurrency,
                                              "network": txnInput.network,
                                              "to_amount": txnInput.targetAmount
                                                  .toString(),
                                              "to_currency":
                                                  txnInput.targetCurrency
                                            }
                                          };
                                        }

                                        try {
                                          setState(() {
                                            _loadingCheckout = true;
                                          });
                                          print(txnInput == null);
                                          final order = await swapController
                                              .sendOrder(orderInput);
                                          //Begin remote config
                                          var sourceCurrenciesObjt =
                                              remoteConfigData
                                                  .countryConfig.entries
                                                  .firstWhere(
                                                    (e) =>
                                                        e.key ==
                                                            user!.country &&
                                                        e.value.enabled == true,
                                                    orElse: () => MapEntry(
                                                        '',
                                                        CountryConfig(
                                                            icon: '',
                                                            enabled: false,
                                                            currencies: {},
                                                            banksWithdraw: null,
                                                            cryptoCurrencies: {})),
                                                  )
                                                  .value;
                                          if (sourceCurrenciesObjt
                                              .currencies.isEmpty) {
                                            throw "Error al obtener currency config.";
                                          }
                                          var bankData = sourceCurrenciesObjt
                                              .currencies.entries
                                              .firstWhere((e) =>
                                                  e.key == sourceCurrency &&
                                                  e.value.enabled == true)
                                              .value
                                              .banks
                                              .entries
                                              .where((element) =>
                                                  element.value.enabled == true)
                                              .map((en) => {
                                                    "name": en.key,
                                                    "info1": en.value.info1,
                                                    "info2": en.value.info2,
                                                    "info3": en.value.info3,
                                                    "info4": en.value.info4,
                                                  })
                                              .toList()[0];

                                          //End remote config
                                          final checkoutData = CheckoutModel(
                                              order: order,
                                              txnInput: txnInput!,
                                              bank: bankData);
                                          context.pushNamed("checkout",
                                              extra: checkoutData);
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                              msg: appLoc
                                                  .errorSomethingWentWrong,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white70);
                                        }
                                        setState(() {
                                          _loadingCheckout = false;
                                        });
                                      }
                                    : null,
                                color: alcanciaLightBlue,
                                width: double.infinity,
                                height: responsiveService.getHeightPixels(
                                    64, screenHeight),
                              ),
                      ),
                      if (sourceAmountController.text.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            validateAmount(sourceAmountController.text,
                                sourceCurrency, appLoc),
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

  void getCurrencyRate() {
    alcanciaUSDtoUSDCRate = remoteConfigCountry.value.cryptoCurrencies.entries
        .firstWhere((e) => e.value.enabled == true && e.key == targetCurrency,
            orElse: () => MapEntry(
                '',
                CryptoCurrency(
                  depositRate: 0.0,
                  enabled: true,
                  icon: "null",
                  maxAmount: 0,
                  minAmount: 0,
                )))
        .value
        .depositRate;
  }

  String validateAmount(
      String sourceAmount, String sourceCurrency, AppLocalizations appLoc) {
    if (sourceCurrency == 'MXN') {
      if (double.parse(sourceAmount) < minMXNAmount)
        return appLoc.errorMinimumDepositAmount;
      if (double.parse(sourceAmount) > maxMXNAmount)
        return appLoc.errorMaximumDepositAmount;
    } else {
      if (double.parse(sourceAmount) < minDOPAmount)
        return appLoc.errorMinimumDepositAmountDOP;
      if (double.parse(sourceAmount) > maxDOPAmount)
        return appLoc.errorMaximumDepositAmountDOP;
    }
    return '';
  }

  bool get _enableButton {
    if (sourceAmountController.text.isEmpty) return false;
    if (sourceCurrency == 'MXN') {
      if (double.parse(sourceAmountController.text) < minMXNAmount)
        return false;
      if (double.parse(sourceAmountController.text) > maxMXNAmount)
        return false;
    } else {
      if (double.parse(sourceAmountController.text) < minDOPAmount)
        return false;
      if (double.parse(sourceAmountController.text) > maxDOPAmount)
        return false;
    }
    return true;
  }
}

String generateCurrency(String sourceCurrency, double suarmiUSDCExchage,
    double alcanciaUSDCExchange, double alcanciaUSDtoUSDCRate) {
  if (sourceCurrency == "MXN") {
    return "*1 USDC = ${suarmiUSDCExchage.formatQuantity(2)} $sourceCurrency";
  } else if (sourceCurrency == "USD") {
    return "*1 USD = ${alcanciaUSDtoUSDCRate.formatQuantity(2)} USDC";
  } else {
    return "*1 USDC = ${alcanciaUSDCExchange.formatQuantity(2)} $sourceCurrency";
  }
}

getIconByCurrencyFlag(String icon) {
  if (icon == "DOP") {
    return "lib/src/resources/images/icon_dominican_flag.png";
  } else if (icon == "USD") {
    return "lib/src/resources/images/icon_us_flag.png";
  } else if (icon == "MXN") {
    return "lib/src/resources/images/icon_mexico_flag.png";
  } else {
    return "Map the source currency!";
  }
}
