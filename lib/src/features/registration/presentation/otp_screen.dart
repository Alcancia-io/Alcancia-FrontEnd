import 'package:alcancia/src/features/registration/model/user_registration_model.dart';
import 'package:alcancia/src/features/registration/provider/registration_controller_provider.dart';
import 'package:alcancia/src/features/registration/provider/timer_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:url_launcher/url_launcher.dart';

class OTPScreen extends ConsumerStatefulWidget {
  OTPScreen({Key? key, required this.userRegistrationData}) : super(key: key);
  final UserRegistrationModel userRegistrationData;
  final Uri url = Uri.parse('');

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final codeController = TextEditingController();
  String error = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(timerProvider);
    final registrationController = ref.watch(registrationControllerProvider);
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
                      const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          "Ya casi \nterminamos,",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "Ingresa el código de 6 dígitos que enviamos a tu celular ${widget.userRegistrationData.user.phoneNumber}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LabeledTextFormField(
                            controller: codeController,
                            autofillHints: [AutofillHints.oneTimeCode],
                            labelText: "Código"),
                      ),
                      StreamBuilder<int>(
                          stream: timer.rawTime,
                          initialData: 0,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            final value = snapshot.data;
                            final displayTime = StopWatchTimer.getDisplayTime(
                                value,
                                hours: false,
                                milliSecond: false);
                            return Center(
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
                                        style:
                                        TextStyle(color: alcanciaLightBlue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿No recibiste el código?"),
                          CupertinoButton(
                            child: const Text(
                              "Reenviar",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: alcanciaLightBlue,
                              ),
                            ),
                            onPressed: timer.rawTime.value == 0 ? () async {
                              await registrationController
                                  .resendVerificationCode(user.email);
                              timer.onResetTimer();
                              timer.onStartTimer();
                            } : null,
                          ),
                        ],
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
                                buttonText: "Crea tu cuenta",
                                onPressed: () async {
                                  if (acceptTerms) {
                                    _setLoading(true);
                                    try {
                                      await registrationController.verifyOTP(
                                          codeController.text,
                                          widget.userRegistrationData.user.email);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(AlcanciaSnackBar(
                                              context,
                                              "Tu cuenta ha sido creada exitosamente. Revisa tu correo para confirmar tu cuenta."));
                                      context.go("/login");
                                    } catch (err) {
                                      setState(() {
                                        error = err.toString();
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      error = err.toString();
                                      _loading = false;
                                    });
                                  }
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
    codeController.dispose();
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
