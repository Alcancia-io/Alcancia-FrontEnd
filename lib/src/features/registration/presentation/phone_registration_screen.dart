import 'package:alcancia/src/features/registration/provider/timer_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/features/registration/data/country.dart';
import 'package:alcancia/src/features/registration/provider/registration_controller_provider.dart';
import 'package:alcancia/src/features/registration/model/user_registration_model.dart';
import 'country_picker.dart';

class PhoneRegistrationScreen extends ConsumerStatefulWidget {
  PhoneRegistrationScreen({Key? key, required this.userRegistrationData})
      : super(key: key);
  final UserRegistrationModel userRegistrationData;
  final Uri url = Uri.parse('');

  @override
  ConsumerState<PhoneRegistrationScreen> createState() => _OTPMethodScreenState();
}

class _OTPMethodScreenState extends ConsumerState<PhoneRegistrationScreen> {
  final selectedCountryProvider =
      StateProvider.autoDispose<Country>((ref) => countries[0]);
  TextEditingController phoneController = TextEditingController();
  bool acceptTerms = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    final selectedCountry = ref.watch(selectedCountryProvider);
    final registrationController = ref.watch(registrationControllerProvider);
    final timer = ref.watch(timerProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AlcanciaToolbar(
                  state: StateToolbar.logoLetters,
                  logoHeight: size.height / 12,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalization.labelPhone,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  Text(
                      appLocalization.labelEnterPhoneNumber,
                      style: const TextStyle(fontSize: 15)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalization.labelPhone),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CountryPicker(
                            selectedCountryProvider: selectedCountryProvider,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              autofillHints: [AutofillHints.telephoneNumber],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appLocalization.errorRequiredField;
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
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
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
                              text: appLocalization.labelReadAndAccepted,
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                TextSpan(
                                  text:
                                      appLocalization.labelPrivacyPolicyAndDataProtection,
                                  style: const TextStyle(color: alcanciaLightBlue),
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
              ),
              Text(
                  appLocalization.labelFeeDisclaimer
              ),
              Spacer(),
              Column(
                children: [
                  AlcanciaButton(
                    buttonText: appLocalization.labelCreateAccount,
                    color: alcanciaLightBlue,
                    width: double.infinity,
                    height: 64,
                    onPressed: () async {
                      if (acceptTerms) {
                        if (phoneController.text.isNotEmpty) {
                          try {
                            final phoneNumber =
                                "+${selectedCountry.dialCode}${phoneController.text}";
                            widget.userRegistrationData.user.phoneNumber = phoneNumber;
                            widget.userRegistrationData.user.country = selectedCountry.code;
                            await registrationController.signUp(widget.userRegistrationData.user, widget.userRegistrationData.password);
                            timer.setPresetMinuteTime(1, add: false);
                            timer.onResetTimer();
                            timer.onStartTimer();
                            context.push("/otp", extra: widget.userRegistrationData);
                          } catch (e) {
                            setState(() {
                              error =
                              e.toString();
                            });
                          }
                        } else {
                          setState(() {
                            error =
                            appLocalization.errorInvalidPhoneNumber;
                          });
                        }
                      } else {
                        setState(() {
                          error =
                          appLocalization.errorAcceptPrivacyPolicy;
                        });
                      }
                    },
                  ),
                  if (error.isNotEmpty) ... [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(widget.url)) {
      throw 'Could not launch $widget.url';
    }
  }
}
