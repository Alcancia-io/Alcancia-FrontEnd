import 'package:alcancia/src/features/registration/provider/timer_provider.dart';
import 'package:alcancia/src/screens/login/login_controller.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:alcancia/src/shared/provider/push_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:alcancia/src/shared/models/storage_item.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MFAScreen extends ConsumerStatefulWidget {
  const MFAScreen({Key? key, required this.data}) : super(key: key);
  final LoginDataModel data;

  @override
  ConsumerState<MFAScreen> createState() => _MFAScreenState();
}

class _MFAScreenState extends ConsumerState<MFAScreen> {
  final loginController = LoginController();
  final codeController = TextEditingController();
  String error = "";
  bool _loading = false;
  final StorageService _storageService = StorageService();

  saveToken(String token) async {
    final StorageItem storageItem = StorageItem("token", token);
    await _storageService.writeSecureData(storageItem);
  }

  @override
  Widget build(BuildContext context) {
    final pushNotifications = ref.watch(pushNotificationProvider);
    final timer = ref.watch(timerProvider);
    final appLoc = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: AlcanciaLogo(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    appLoc.labelVerifyIdentity,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                      appLoc.labelEnterCodePhone(widget.data.phoneNumber.substring(widget.data.phoneNumber.length - 4)),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: LabeledTextFormField(
                      controller: codeController,
                      inputType: TextInputType.number,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      labelText: appLoc.labelCode),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: StreamBuilder<int>(
                    stream: timer.rawTime,
                    initialData: 0,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      final value = snapshot.data;
                      final displayTime = StopWatchTimer.getDisplayTime(value, hours: false, milliSecond: false);
                      return Column(
                        children: [
                          Center(
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: const BorderSide(color: alcanciaLightBlue))),
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
                                      style: const TextStyle(color: alcanciaLightBlue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(appLoc.labelDidNotReceiveCode),
                              TextButton(
                                onPressed: value <= 0
                                    ? () async {
                                        final deviceToken = await pushNotifications.messaging.getToken();
                                        final token = await loginController.login(
                                            widget.data.email, widget.data.password, deviceToken ?? "");
                                        saveToken(token);
                                        timer.onResetTimer();
                                        timer.onStartTimer();
                                      }
                                    : null,
                                style: TextButton.styleFrom(foregroundColor: alcanciaLightBlue),
                                child: Text(
                                  appLoc.buttonResend,
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
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Column(
                      children: [
                        if (_loading) ...[
                          const CircularProgressIndicator(),
                        ] else ...[
                          AlcanciaButton(
                            color: alcanciaLightBlue,
                            width: 308,
                            height: 64,
                            buttonText: appLoc.buttonLogIn,
                            onPressed: () async {
                              _setLoading(true);
                              try {
                                final completed = await loginController.completeSignIn(codeController.text);
                                if (completed) context.go("/homescreen/0");
                              } catch (err) {
                                setState(() {
                                  error = err.toString();
                                });
                              }
                              _setLoading(false);
                            },
                          ),
                          Text(
                            error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
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
    codeController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }
}
