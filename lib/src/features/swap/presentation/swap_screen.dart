import 'dart:developer';

import 'package:alcancia/src/features/swap/data/exchange_api.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/metamap/metamap_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_link.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/user_provider.dart';
import 'package:alcancia/src/shared/services/exchange_api_service.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/screens/metamap/metamap_dialog.dart';

class SwapScreen extends ConsumerStatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends ConsumerState<SwapScreen> {
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

  // metamap
  final MetaMapController metaMapController = MetaMapController();
  final metamapDomicanFlowId = dotenv.env['DOMINICAN_FLOW_ID'] as String;
  final metamapMexicanResidentId =
      dotenv.env['MEXICO_RESIDENTS_FLOW_ID'] as String;
  final metamapMexicanINEId = dotenv.env['MEXICO_INE_FLOW_ID'] as String;

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    inspect(user);
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

                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                if (snapshot.hasData) {
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
                          left:
                              responsiveService.getWidthPixels(30, screenWidth),
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
                                          dropdownHeight:
                                              responsiveService.getHeightPixels(
                                                  45, screenHeight),
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
                                          width:
                                              responsiveService.getWidthPixels(
                                            150,
                                            screenWidth,
                                          ),
                                          child: TextField(
                                            style:
                                                const TextStyle(fontSize: 15),
                                            decoration: InputDecoration(
                                              fillColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            inputFormatters: <
                                                TextInputFormatter>[
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
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        height:
                                            responsiveService.getHeightPixels(
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
                                              : (int.parse(
                                                          sourceAmountController
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
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 12),
                              child: AlcanciaButton(
                                buttonText: "Transferencia",
                                onPressed: () async {
                                  //Temporary Variables
                                  var verified = user!.kycVerified;
                                  var resident = false;

                                  if (verified) {
                                    context.push('/');
                                    // go to checkout form
                                  } else {
                                    if (sourceDropdownVal == 'MXN') {
                                      final UserStatus status =
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const UserStatusDialog();
                                              });
                                      resident = status == UserStatus.resident;
                                    }
                                    if (sourceDropdownVal == 'MXN' &&
                                        resident) {
                                      metaMapController.showMatiFlow(
                                          metamapMexicanResidentId,
                                          user.userId);
                                    }
                                    if (sourceDropdownVal == 'MXN' &&
                                        !resident) {
                                      metaMapController.showMatiFlow(
                                          metamapMexicanINEId, user.userId);
                                    }

                                    if (sourceDropdownVal == "DOP") {
                                      metaMapController.showMatiFlow(
                                          metamapDomicanFlowId, user.userId);
                                    }
                                  }
                                },
                                color: alcanciaLightBlue,
                                width: double.infinity,
                                height: responsiveService.getHeightPixels(
                                  64,
                                  screenHeight,
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
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
