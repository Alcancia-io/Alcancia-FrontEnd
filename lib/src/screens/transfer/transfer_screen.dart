import 'package:alcancia/src/features/registration/data/country.dart';
import 'package:alcancia/src/features/registration/presentation/country_picker.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/transfer/transfer_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_confirmation_dialog.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/decimal_input_formatter.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/provider/user_provider.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final List<Map> countries = [
    {"value": "MX", "name": "+52", "icon": "lib/src/resources/images/icon_mexico_flag.png"},
    {"value": "CO", "name": "+57", "icon": "lib/src/resources/images/icon_colombia_flag.png"},
    {"value": "DO", "name": "+1", "icon": "lib/src/resources/images/icon_dominican_flag.png"},
    {"value": "US", "name": "+1", "icon": "lib/src/resources/images/icon_us_flag.png"},
  ];
  late String countryCode = countries.first['name'];

  final _responsiveService = ResponsiveService();

  final _formKey = GlobalKey<FormState>();

  bool _enableButton = false;
  bool _loading = false;

  String _error = "";

  final _phoneController = TextEditingController();
  final _transferAmountController = TextEditingController();

  final List<Map> sourceCurrencies = [
    {"name": "USDC", "icon": "lib/src/resources/images/icon_usdc.png"},
    {"name": "cUSD", "icon": "lib/src/resources/images/icon_celo_usd.png"},
  ];
  late String sourceCurrency = sourceCurrencies.first['name'];

  final transferController = TransferController();

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;
    final userBalance = ref.watch(balanceProvider);
    final user = ref.watch(userProvider);
    final balance = sourceCurrency == "USDC" ? userBalance.usdcBalance : userBalance.celoBalance;
    final screenHeight = MediaQuery.of(context).size.height;

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
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      appLoc.labelWithdrawInformationPrompt,
                      style: txtTheme.bodyText1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLoc.labelPhone),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AlcanciaDropdown(
                              itemsAlignment: MainAxisAlignment.spaceBetween,
                              dropdownItems: countries,
                              dropdownWidth: _responsiveService.getWidthPixels(50, screenHeight),
                              dropdownHeight: _responsiveService.getHeightPixels(55, screenHeight),
                              decoration: BoxDecoration(
                                color: Theme.of(context).inputDecorationTheme.fillColor,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  countryCode = countries
                                      .firstWhere((element) => element['value'] == value)['name'];
                                  _enableButton = _formKey.currentState!.validate();
                                });
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyText1,
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  autofillHints: [AutofillHints.telephoneNumber],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return appLoc.errorRequiredField;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLoc.labelTransferAmount),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AlcanciaDropdown(
                              itemsAlignment: MainAxisAlignment.spaceBetween,
                              dropdownItems: sourceCurrencies,
                              dropdownWidth: _responsiveService.getWidthPixels(55, screenHeight),
                              dropdownHeight: _responsiveService.getHeightPixels(55, screenHeight),
                              decoration: BoxDecoration(
                                color: Theme.of(context).inputDecorationTheme.fillColor,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  sourceCurrency = value;
                                  _enableButton = _formKey.currentState!.validate();
                                });
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyText1,
                                  controller: _transferAmountController,
                                  keyboardType: TextInputType.number,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(appLoc.labelAvailableBalance(balance.toStringAsFixed(2))),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Center(
                      child: Column(
                        children: [
                          if (_loading) ...[
                            const CircularProgressIndicator(),
                          ] else ...[
                            AlcanciaButton(
                              buttonText: appLoc.buttonNext,
                              // TODO: enableButton again
                              onPressed: true
                                  ? () async {
                                      setState(() {
                                        _loading = true;
                                      });
                                      try {
                                        final phoneNumber = countryCode + _phoneController.text;
                                        final currency = sourceCurrency;
                                        print(phoneNumber);
                                        print(currency);
                                        print(balance);
                                        print(user!.id);
                                        print(_transferAmountController.text);
                                        final amount = double.parse(_transferAmountController.text);
                                        final targetUser = await transferController.searchUser(
                                            phoneNumber: phoneNumber);
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlcanciaConfirmationDialog(
                                                targetUser: targetUser,
                                                userBalance: balance,
                                                amount: amount,
                                                currency: currency,
                                                onConfirm: () async {
                                                  // TODO: Call transfer method and pass data to success screen
                                                  final transaction =
                                                      await transferController.transferFunds(
                                                          amount: amount.toStringAsFixed(2),
                                                          destionationUserId: targetUser.id,
                                                          sourceUserId: user!.id,
                                                          token: currency);
                                                  context.pushNamed('successful-transaction');
                                                },
                                              );
                                            });
                                      } catch (e) {
                                        _error = e.toString();
                                      }
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  : null,
                              color: alcanciaLightBlue,
                              width: 308,
                              height: 64,
                            ),
                          ],
                          if (_error.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                _error,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
