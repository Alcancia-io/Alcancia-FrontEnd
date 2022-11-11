import 'package:alcancia/src/features/registration/provider/registration_controller_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/provider/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OTPScreen extends ConsumerStatefulWidget {
  OTPScreen({Key? key}) : super(key: key);
  final Uri url = Uri.parse('https://flutter.dev');

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final codeController = TextEditingController();
  bool acceptTerms = false;
  String error = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
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
                            "Ingresa el código de 6 dígitos que enviamos a tu celular ${user!.phoneNumber}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LabeledTextFormField(
                            controller: codeController,
                            autofillHints: [AutofillHints.oneTimeCode],
                            labelText: "Código"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 25,
                            child: Checkbox(
                                value: acceptTerms,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      acceptTerms = value;
                                    });
                                  }
                                }),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: RichText(
                                text: TextSpan(
                                    text: "He leído y acepto la ",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    children: [
                                      TextSpan(
                                        text:
                                            "Política de Privacidad y Tratamiento de Datos",
                                        style:
                                            TextStyle(color: alcanciaLightBlue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _launchUrl();
                                          },
                                      )
                                    ]),
                              ),
                            ),
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
                                          user.email);
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
                                      error =
                                          "Acepta la Política de Privacidad";
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
