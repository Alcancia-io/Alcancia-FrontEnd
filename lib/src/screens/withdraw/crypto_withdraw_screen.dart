import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/error/error_screen.dart';
import 'package:alcancia/src/screens/withdraw/withdraw_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/decimal_input_formatter.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:alcancia/src/shared/models/storage_item.dart';
import 'package:alcancia/src/shared/models/success_screen_model.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
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
  final _storageService = StorageService();
  final _formKey = GlobalKey<FormState>();

  final _walletAddressController = TextEditingController();
  final _networkController = TextEditingController(text: "POLYGON");
  final _amountTextController = TextEditingController();

  double _fee = 0;


  Future<void> sendOrder(AppLocalizations appLoc) async {
    walletController.sendExternalWithdrawal(amount: _amountTextController.text, address: _walletAddressController.text).then((value) {
      Fluttertoast.showToast(
        msg: appLoc.alertWithdrawalSuccessful,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }, onError: (e) {
      Fluttertoast.showToast(
        msg: appLoc.errorWithdrawalFailed,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  Future<void> getCryptoWithdrawalFee() async {
    try {
      _isLoading = true;
      final latestFeeString = await _storageService.readSecureData("cryptoWithdrawalFee");
      final latestFeeExpirationString = await _storageService.readSecureData("cryptoWithdrawalFeeExpiration");
      final latestFee = latestFeeString != null ? double.parse(latestFeeString) : null;
      final latestFeeExpiration = latestFeeExpirationString != null ? DateTime.parse(latestFeeExpirationString) : null;
      final validFee = latestFeeExpiration != null && latestFeeExpiration.isAfter(DateTime.now());
      if (latestFee != null && validFee) {
          setState(() {
            _isLoading = false;
            _fee = latestFee;
          });
      } else {
        final fee = await walletController.getCryptoWithdrawalFee();
        StorageItem feeItem = StorageItem("cryptoWithdrawalFee", fee.toString());
        StorageItem feeExpirationItem = StorageItem("cryptoWithdrawalFeeExpiration", DateTime.now().add(const Duration(days: 1)).toString());
        await _storageService.writeSecureData(feeItem);
        await _storageService.writeSecureData(feeExpirationItem);
        setState(() {
          _isLoading = false;
          _fee = fee;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCryptoWithdrawalFee();
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final txtTheme = Theme.of(context).textTheme;
    final totalUserBalance = ref.watch(balanceProvider);
    final balance = totalUserBalance.total - _fee;

    if (_isLoading) {
      return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
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
                  if (value == null || value.isEmpty) {
                    return appLoc.errorRequiredField;
                  } else if (balance < double.parse(value)) {
                    return appLoc.errorInsufficientBalance;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(appLoc.labelAvailableBalance(balance > 0 ? balance.toStringAsFixed(3) : "0.00")),
              const SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appLoc.labelWithdrawalFee, style: txtTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                  Text("$_fee USDC", style: txtTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(
                height: 70,
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
                          sendOrder(appLoc);
                          setState(() {
                            _loadingButton = false;
                          });
                          context.go("/success", extra: SuccessScreenModel(title: appLoc.labelWithdrawalConfirmed, subtitle: appLoc.labelWithdrawalProcessingTime));
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
      ),
    );
  }
}
