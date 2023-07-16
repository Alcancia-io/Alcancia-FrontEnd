import 'package:alcancia/src/features/registration/provider/registration_controller_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../screens/login/login_controller.dart';
import '../../../shared/models/storage_item.dart';
import '../../../shared/provider/push_notifications_provider.dart';
import '../../../shared/services/storage_service.dart';

class OTPScreen extends ConsumerStatefulWidget {
  OTPScreen({Key? key, required this.otpDataModel}) : super(key: key);
  final OTPDataModel otpDataModel;
  final Uri url = Uri.parse('');

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final _codeController = TextEditingController();
  final loginController = LoginController();
  String _error = "";
  bool _loading = false;
  final StorageService _storageService = StorageService();
  final timer =
      StopWatchTimer(mode: StopWatchMode.countDown, presetMillisecond: 60000);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer.onStartTimer();
  }

  @override
  Widget build(BuildContext context) {
    final registrationController = ref.watch(registrationControllerProvider);
    final appLocalization = AppLocalizations.of(context)!;
    final pushNotifications = ref.watch(pushNotificationProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: AlcanciaLogo(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    appLocalization.labelAlmostDone,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(appLocalization.labelEnterCodePhone(
                      widget.otpDataModel.phoneNumber ?? "")),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: LabeledTextFormField(
                      controller: _codeController,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      labelText: appLocalization.labelCode),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: StreamBuilder<int>(
                      stream: timer.rawTime,
                      initialData: 0,
                      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                        final value = snapshot.data;
                        final displayTime = StopWatchTimer.getDisplayTime(value,
                            hours: false, milliSecond: false);
                        return Column(
                          children: [
                            Center(
                              child: Container(
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        side: const BorderSide(
                                            color: alcanciaLightBlue))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.timer_sharp,
                                        color: alcanciaLightBlue,
                                      ),
                                      Text(
                                        displayTime,
                                        style: const TextStyle(
                                            color: alcanciaLightBlue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(appLocalization.labelDidNotReceiveCode),
                                TextButton(
                                  onPressed: value <= 0
                                      ? () async {
                                          await registrationController
                                              .resendVerificationCode(
                                                  widget.otpDataModel.email);
                                          timer.onResetTimer();
                                          timer.onStartTimer();
                                        }
                                      : null,
                                  style: TextButton.styleFrom(
                                      foregroundColor: alcanciaLightBlue),
                                  child: Text(
                                    appLocalization.buttonResend,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
                Center(
                  child: Column(
                    children: [
                      if (_loading) ...[
                        const CircularProgressIndicator(),
                      ] else ...[
                        AlcanciaButton(
                          color: alcanciaLightBlue,
                          width: 308,
                          height: 64,
                          buttonText: appLocalization.buttonNext,
                          onPressed: () async {
                            _setLoading(true);
                            try {
                              await registrationController.verifyOTP(
                                  _codeController.text,
                                  widget.otpDataModel.email);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  alcanciaSnackBar(context,
                                      appLocalization.labelAccountCreated));
                              try {
                                final deviceToken = await pushNotifications
                                    .messaging
                                    .getToken();
                                final data = await loginController.login(
                                    widget.otpDataModel.email,
                                    widget.otpDataModel.password!,
                                    deviceToken ?? "");
                                await saveToken(data.token);
                                await saveUserInfo(data.name, data.email);

                                final completed = await loginController
                                    .completeSignIn(_codeController.text);
                                if (completed) context.go("/homescreen/0");
                              } catch (err) {
                                setState(() {
                                  _error = appLocalization.labelErrorOtp;
                                });
                              }
                            } catch (err) {
                              setState(() {
                                _error = appLocalization.labelErrorOtp;
                              });
                            }
                            _setLoading(false);
                          },
                        ),
                        Text(
                          _error,
                          style: const TextStyle(color: Colors.red),
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

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> saveToken(String token) async {
    final StorageItem storageItem = StorageItem("token", token);
    await _storageService.writeSecureData(storageItem);
  }

  Future<void> saveUserInfo(String name, String email) async {
    final StorageItem userName = StorageItem("userName", name);
    final StorageItem userEmail = StorageItem("userEmail", email);

    await _storageService.writeSecureData(userName);
    await _storageService.writeSecureData(userEmail);
  }

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }
}
