import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/error/error_screen.dart';
import 'package:alcancia/src/screens/withdraw/withdraw_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/decimal_input_formatter.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class CryptoWithdrawScreen extends ConsumerStatefulWidget {
  const CryptoWithdrawScreen({super.key});

  @override
  ConsumerState<CryptoWithdrawScreen> createState() => _CryptoWithdrawScreenState();
}

class _CryptoWithdrawScreenState extends ConsumerState<CryptoWithdrawScreen> {
  String _error = "";
  bool _isLoading = false;

  bool _loadingButton = false;
  bool _enableButton = false;

  final walletController = WithdrawController();
  final _formKey = GlobalKey<FormState>();

  final _walletAddressController = TextEditingController();
  final _networkController = TextEditingController(text: "POLYGON");
  final _amountTextController = TextEditingController();


  Future<void> sendOrder() async {
    walletController.sendExternalWithdrawal(amount: _amountTextController.text, address: _walletAddressController.text).then((value) {
      Fluttertoast.showToast(
        msg: "Withdrawal completed successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }, onError: (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
    Fluttertoast.showToast(
      msg: "Withdrawal sent",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;
    final totalUserBalance = ref.watch(balanceProvider);
    final balance = totalUserBalance.usdcBalance - 1;

    if (_isLoading) {
      return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
    }

    if (_error != "") {
      return const ErrorScreen();
    }

    return Scaffold(
      appBar: AlcanciaToolbar(
        title: appLoc.labelMoneyWithdrawal,
        state: StateToolbar.titleIcon,
        logoHeight: 40,
      ),
      body: SafeArea(
          child: Form(
            key: _formKey,
        onChanged: () => setState(() => _enableButton = _formKey.currentState!.validate()),
        child: ListView(
          padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
          children: [
            Text(
              appLoc.labelHello,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                appLoc.labelWithdrawInformationPrompt,
                style: txtTheme.bodyText1,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            LabeledTextFormField(controller: _walletAddressController, labelText: appLoc.labelAddress, validator: (value) {
              if (value == null || value.isEmpty) {
                return appLoc.errorRequiredField;
              } else if (!value.isValidWalletAddress()) {
                return appLoc.errorInvalidWalletAddress;
              }
              return null;
            },),
            const SizedBox(
              height: 20,
            ),
            LabeledTextFormField(controller: _networkController, labelText: appLoc.labelNetwork, enabled: false,),
            const SizedBox(
              height: 20,
            ),
            LabeledTextFormField(
              controller: _amountTextController,
              labelText: appLoc.labelWithdrawAmount,
              inputType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              validator: (value) {
                return null;
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
            const SizedBox(
              height: 10,
            ),
            Text(appLoc.labelAvailableBalance(balance.toStringAsFixed(2))),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Comisión de retiro", style: txtTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                Text("1 USDC", style: txtTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
              ],
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
                        sendOrder();
                        setState(() {
                          _loadingButton = false;
                        });
                        context.go('/');
                      }
                          : null,
                      color: alcanciaLightBlue,
                      width: 308,
                      height: 64,
                    ),
                  ],
                  if (_error.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
