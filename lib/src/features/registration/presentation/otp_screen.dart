import 'package:alcancia/src/features/registration/provider/registration_controller_provider.dart';
import 'package:alcancia/src/features/registration/provider/timer_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OTPScreen extends ConsumerStatefulWidget {
  OTPScreen({Key? key, required this.otpDataModel}) : super(key: key);
  final OTPDataModel otpDataModel;
  final Uri url = Uri.parse('');

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final _codeController = TextEditingController();
  String _error = "";
  bool _loading = false;

  String _bodyText() {
    if (widget.otpDataModel.phoneNumber != null) {
      return "Ingresa el código de 6 dígitos que enviamos a tu celular ${widget.otpDataModel.phoneNumber}";
    }
    return "Ingresa el código de 6 dígitos que enviamos a tu celular";
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(timerProvider);
    final registrationController = ref.watch(registrationControllerProvider);
    final appLocalization = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AlcanciaLogo(),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          appLocalization.labelAlmostDone,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            appLocalization.labelEnterCodePhone(widget.userRegistrationData.user.phoneNumber)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LabeledTextFormField(
                            controller: _codeController,
                            autofillHints: [AutofillHints.oneTimeCode],
                            labelText: appLocalization.labelCode),
                      ),
                      StreamBuilder<int>(
                          stream: timer.rawTime,
                          initialData: 0,
                          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                            final value = snapshot.data;
                            final displayTime = StopWatchTimer.getDisplayTime(
                                value,
                                hours: false,
                                milliSecond: false);
                            return Column(
                              children: [
                                Center(
                                  child: Container(
                                    decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            side: BorderSide(
                                                color: alcanciaLightBlue))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.timer_sharp,
                                            color: alcanciaLightBlue,
                                          ),
                                          Text(
                                            displayTime,
                                            style: TextStyle(
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
                                                  .resendVerificationCode(widget
                                                      .otpDataModel
                                                      .email);
                                              timer.onResetTimer();
                                              timer.onStartTimer();
                                            }
                                          : null,
                                      style: TextButton.styleFrom(foregroundColor: alcanciaLightBlue),
                                      child: Text(
                                        appLocalization.labelResend,
                                        style: TextStyle(
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
                                buttonText: appLocalization.labelNext,
                                onPressed: () async {
                                  _setLoading(true);
                                  try {
                                    await registrationController.verifyOTP(
                                        _codeController.text,
                                        widget.otpDataModel.email);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        AlcanciaSnackBar(context,
                                            appLocalization.labelAccountCreated));
                                    context.go("/login");
                                  } catch (err) {
                                    setState(() {
                                      _error = err.toString();
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(widget.url)) {
      throw 'Could not launch $widget.url';
    }
  }

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }
}
