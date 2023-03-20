import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/investment_info/investment_info.dart';
import 'package:alcancia/src/screens/swap/components/currency_risk_card.dart';
import 'package:alcancia/src/screens/swap/swap_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_container.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/constants.dart';
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

class SwapScreen extends ConsumerStatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends ConsumerState<SwapScreen> {
  // source amount vars
  late String sourceAmount = ""; // value entered in text field
  final sourceAmountController = TextEditingController();

  // source amount icons
  final List<Map> sourceCurrencyCodes = [
    {"name": "MXN", "icon": "lib/src/resources/images/icon_mexico_flag.png"},
    // {"name": "DOP", "icon": "lib/src/resources/images/icon_dominican_flag.png"},
  ];

  // target amount icons
  final List<Map> targetCurrencies = [
    {"name": "CUSD", "icon": "lib/src/resources/images/icon_celo_usd.png"},
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
  ];

  // dropdown value for target currency, it can be CUSD or USDC
  late String targetCurrency = targetCurrencies.first['name'];

  // dropdown value for source currency, it can be MXN or DOP
  late String sourceCurrency = sourceCurrencyCodes.first['name'];
  final ResponsiveService responsiveService = ResponsiveService();

  // metamap
  final MetamapService metaMapService = MetamapService();
  final metamapMexicanINEId = dotenv.env['MEXICO_INE_FLOW_ID'] as String;
  final metamapDomicanFlowId = dotenv.env['DOMINICAN_FLOW_ID'] as String;

  final SwapController swapController = SwapController();

  // suarmi exchanges
  var suarmiUSDCExchage = 1.0;
  var suarmiCeloExchange = 1.0;

  // state
  bool _isLoading = false;
  String _error = "";

  // Anual Percentage Yields
  String currentCeloAPY = "";
  String? celoAPYError;

  String currentUsdcAPY = "";
  String? usdcAPYError;

  // investment info
  final usdcInfo = [usdcDescription, usdcProtocolDescription];
  final celoInfo = [celoDescription, celoProtocolDescription];

  getExchange() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var exchageRate = await swapController.getSuarmiExchange("USDC");
      var celoRate = await swapController.getSuarmiExchange("cUSD");
      setState(() {
        suarmiUSDCExchage = 1.0 / double.parse(exchageRate);
        suarmiCeloExchange = 1.0 / double.parse(celoRate);
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
      var currentUsdcAPYResponse = await swapController.getCurrentAPY("aPolUSDC");
      setState(() {
        currentUsdcAPY = currentUsdcAPYResponse;
      });
    } on CustomException catch (err) {
      usdcAPYError = err.message;
    }
  }

  @override
  void initState() {
    super.initState();
    getExchange();
    getCeloAPY();
    getUsdcAPY();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);

    final txtTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
    }

    if (_error != "") return Scaffold(body: SafeArea(child: Center(child: Text(_error))));

    Color cardColor = Theme.of(context).brightness == Brightness.dark ? alcanciaCardDark : alcanciaFieldLight;

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
                        child: Text("Deposita a tu cuenta", style: txtTheme.subtitle1),
                      ),
                      AlcanciaContainer(
                        bottom: 32,
                        child: Text("¡Empecemos!", style: txtTheme.headline1),
                      ),
                      AlcanciaContainer(
                        bottom: 30,
                        child: Text(
                          "Ingresa el monto que deseas convertir de nuestra opciones. A continuación, se presenta a cuanto equivale en",
                          style: txtTheme.bodyText1,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: responsiveService.getHeightPixels(20, screenHeight),
                          bottom: responsiveService.getHeightPixels(20, screenHeight),
                          left: responsiveService.getWidthPixels(12, screenWidth),
                          right: responsiveService.getWidthPixels(12, screenWidth),
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: const BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("¿Cuánto deseas convertir?", style: txtTheme.bodyText1),
                            AlcanciaContainer(
                              top: 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AlcanciaDropdown(
                                    dropdownWidth: responsiveService.getWidthPixels(150, screenWidth),
                                    dropdownHeight: responsiveService.getHeightPixels(45, screenHeight),
                                    dropdownItems: sourceCurrencyCodes,
                                    onChanged: (newValue) {
                                      setState(() {
                                        sourceCurrency = newValue;
                                        // when this components intis, we will exchange rate from suarmi and cryptopay
                                      });
                                    },
                                  ),
                                  // this is the input field where user enters source amount
                                  AlcanciaContainer(
                                    height: responsiveService.getHeightPixels(45, screenHeight),
                                    width: responsiveService.getWidthPixels(150, screenWidth),
                                    child: TextField(
                                      style: const TextStyle(fontSize: 15),
                                      decoration: InputDecoration(
                                        fillColor: Theme.of(context).primaryColor,
                                      ),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      keyboardType: TextInputType.number,
                                      controller: sourceAmountController,
                                      onChanged: (text) {
                                        setState(() {
                                          sourceAmount = text;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Center(child: SvgPicture.asset("lib/src/resources/images/arrow_down_purple.svg")),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AlcanciaDropdown(
                                  dropdownWidth: responsiveService.getWidthPixels(150, screenWidth),
                                  dropdownHeight: responsiveService.getHeightPixels(45, screenHeight),
                                  dropdownItems: targetCurrencies,
                                  onChanged: (newTargetCurrency) {
                                    setState(() {
                                      targetCurrency = newTargetCurrency;
                                    });
                                  },
                                ),
                                // here is where target amount is display
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  height: responsiveService.getHeightPixels(45, screenHeight),
                                  width: responsiveService.getWidthPixels(150, screenWidth),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    sourceAmount == ""
                                        ? ""
                                        : (int.parse(sourceAmountController.text) /
                                                (targetCurrency == "USDC" ? suarmiUSDCExchage : suarmiCeloExchange))
                                            .toStringAsFixed(4),
                                    style: txtTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (celoAPYError != null) ...[
                        Text(celoAPYError as String)
                      ] else if (targetCurrency == "CUSD") ...[
                        AlcanciaContainer(
                          top: 16,
                          child: CurrencyRiskCard(
                            riskLevel: RiskLevel.medio,
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
                            riskLevel: RiskLevel.bajo,
                            targetCurrency: "USDC",
                            percentage: currentUsdcAPY,
                            color: cardColor,
                          ),
                        ),
                      ],
                      AlcanciaContainer(
                        top: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: alcanciaLightBlue),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                icon: SvgPicture.asset(
                                  "lib/src/resources/images/icon_lamp.svg",
                                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : null,
                                ),
                                label: Text(
                                  '¿En que estoy invirtiendo?',
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
                          "Medio de pago:",
                          style: txtTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 12),
                        child: AlcanciaButton(
                          buttonText: "Transferencia",
                          onPressed: sourceAmount.isEmpty || int.parse(sourceAmount) < 200
                              ? null
                              : () async {
                                  //Temporary Variables
                                  var verified = user!.kycStatus;
                                  var resident = false;

                                  if (verified == "VERIFIED") {
                                    final method = sourceCurrency == 'MXN'
                                        ? TransactionMethod.suarmi
                                        : TransactionMethod.cryptopay;
                                    final txnInput = TransactionInput(
                                      txnMethod: method,
                                      txnType: TransactionType.deposit,
                                      sourceAmount: double.parse(sourceAmount),
                                      targetAmount: (double.parse(sourceAmountController.text) /
                                          (targetCurrency == "USDC" ? suarmiUSDCExchage : suarmiCeloExchange)),
                                      targetCurrency: targetCurrency == 'USDC' ? 'aPolUSDC' : 'mcUSD',
                                      network: targetCurrency == 'USDC' ? 'MATIC' : 'CELO',
                                    );
                                    Map wrapper = {
                                      "verified": true,
                                      "txnInput": txnInput,
                                    };
                                    if (user.address == null || user.profession == null) {
                                      context.pushNamed('user-address', extra: wrapper);
                                    } else {
                                      context.pushNamed("checkout", extra: txnInput);
                                    }
                                  } else if (verified == "PENDING") {
                                    Fluttertoast.showToast(
                                        msg: "Revisión en proceso, espera un momento...",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM);
                                  } else if (verified == "FAILED" || verified == null) {
                                    if (sourceCurrency == 'MXN') {
                                      if (user.address != null && user.profession != null) {
                                        await metaMapService.showMatiFlow(metamapMexicanINEId, user.id);
                                      } else {
                                        context.pushNamed("user-address", extra: {"verified": false});
                                      }
                                    }
                                  }
                                },
                          color: alcanciaLightBlue,
                          width: double.infinity,
                          height: responsiveService.getHeightPixels(64, screenHeight),
                        ),
                      ),
                      if (sourceAmount.isNotEmpty && int.parse(sourceAmount) < 200) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Cantidad mínima de \$200",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
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
}
