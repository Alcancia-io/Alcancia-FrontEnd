import 'package:alcancia/src/features/ramp/presentation/ramp-payment.dart';
import 'package:alcancia/src/features/swap/data/exchange_api.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_link.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:alcancia/src/shared/services/exchange_api_service.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SwapScreen extends ConsumerStatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends ConsumerState<SwapScreen> {
  RampPaymentService _rampPaymentService = RampPaymentService();
  ExchangeApiService exchangeApiService =
      ExchangeApiService(baseCurrencyCode: "USD");
  late String targetAmount = "";
  final sourceAmountController = TextEditingController();
  final String baseCurrencyCode = "USD";
  final List<Map> targetCurrencyCodes = [
    {"name": "MXN", "icon": "lib/src/resources/images/icon_mexico_flag.png"},
    {"name": "DOP", "icon": "lib/src/resources/images/icon_dominican_flag.png"},
  ];
  final List<Map> baseCurrencyCodes = [
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
  ];

  late String sourceDropdownVal = targetCurrencyCodes.first['name'];
  final ResponsiveService responsiveService = ResponsiveService();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    print('this is the user in the swap screen');
    print(user?.email);
    print(user?.walletAddress);
    final txtTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder<ExchangeApi>(
              future: exchangeApiService.fetchCurrency(sourceDropdownVal),
              builder: (context, snapshot) {
                var conversionRate = snapshot.data?.conversionRate;
                if (targetAmount == "") {}
                var usdc = targetAmount == ""
                    ? 0.0
                    : int.parse(sourceAmountController.text) / conversionRate!;
                // if (snapshot.hasError) {
                //   return Text("${snapshot.error}");
                // }
                // if (snapshot.hasData) {
                return Column(
                  children: [
                    AlcanciaToolbar(
                      state: StateToolbar.logoNoletters,
                      logoHeight: responsiveService.getHeightPixels(
                        40,
                        screenHeight,
                      ),
                    ),

                    // general container, sets padding
                    Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: responsiveService.getWidthPixels(30, screenWidth),
                        right:
                            responsiveService.getWidthPixels(30, screenWidth),
                        bottom: 34,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: responsiveService.getHeightPixels(
                                4,
                                screenHeight,
                              ),
                              bottom: responsiveService.getHeightPixels(
                                32,
                                screenHeight,
                              ),
                            ),
                            child: Text(
                              "Deposita a tu cuenta",
                              style: txtTheme.subtitle1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: responsiveService.getHeightPixels(
                                32,
                                screenHeight,
                              ),
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
                            padding: EdgeInsets.only(
                              top: responsiveService.getHeightPixels(
                                20,
                                screenHeight,
                              ),
                              bottom: responsiveService.getHeightPixels(
                                20,
                                screenHeight,
                              ),
                              left: responsiveService.getWidthPixels(
                                12,
                                screenWidth,
                              ),
                              right: responsiveService.getWidthPixels(
                                12,
                                screenWidth,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? alcanciaCardDark
                                  : alcanciaFieldLight,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
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
                                        dropdownWidth:
                                            responsiveService.getWidthPixels(
                                          150,
                                          screenWidth,
                                        ),
                                        dropdownHeight: responsiveService
                                            .getHeightPixels(45, screenHeight),
                                        dropdownItems: targetCurrencyCodes,
                                        onChanged: (newValue) {
                                          setState(() {
                                            sourceDropdownVal = newValue;
                                            exchangeApiService
                                                .fetchCurrency(newValue);
                                          });
                                        },
                                      ),
                                      // this is the input field
                                      SizedBox(
                                        height:
                                            responsiveService.getHeightPixels(
                                          45,
                                          screenHeight,
                                        ),
                                        width: responsiveService.getWidthPixels(
                                          150,
                                          screenWidth,
                                        ),
                                        child: TextField(
                                          style: const TextStyle(fontSize: 15),
                                          decoration: InputDecoration(
                                            fillColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
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
                                      const EdgeInsets.only(top: 8, bottom: 8),
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
                                      dropdownWidth: responsiveService
                                          .getWidthPixels(150, screenWidth),
                                      dropdownHeight: responsiveService
                                          .getHeightPixels(45, screenHeight),
                                      dropdownItems: baseCurrencyCodes,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      height: responsiveService.getHeightPixels(
                                        45,
                                        screenHeight,
                                      ),
                                      width: responsiveService.getWidthPixels(
                                        150,
                                        screenWidth,
                                      ),
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
                              onPressed: () {
                                // _rampPaymentService.presentRamp(
                                //     usdc,
                                //     user?.email,
                                //     user?.walletAddress,
                                //     sourceDropdownVal);
                                _launchUrl(Uri.parse(
                                    "https://ri-widget-staging.firebaseapp.com/?userAddress=${user?.walletAddress}&userEmailAddress=${user?.email}&fiatValue=${usdc?.toStringAsFixed(2)}&fiatCurrency=USD&selectedCountryCode=MX&hostApiKey=${dotenv.env['RAMP_STAGE_KEY']}&swapAsset=CELO_CUSD"));
                              },
                              color: alcanciaLightBlue,
                              width: double.infinity,
                              height: responsiveService.getHeightPixels(
                                64,
                                screenHeight,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 12),
                            child: SizedBox(
                              height: responsiveService.getHeightPixels(
                                64,
                                screenHeight,
                              ),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFC9E0FF),
                                ),
                                onPressed: () {},
                                child: const Image(
                                  image: AssetImage(
                                      "lib/src/resources/images/Coinbase 2.png"),
                                ),
                              ),
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
                // }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
