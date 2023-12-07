// Flutter package imports:
import 'package:alcancia/src/features/registration/model/registration_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Other package imports:
import 'package:go_router/go_router.dart';

// Relative imports:
import 'package:alcancia/src/features/registration/provider/registration_controller_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/login/login_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
import 'package:alcancia/src/shared/models/storage_item.dart';
import 'package:alcancia/src/shared/provider/push_notifications_provider.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';

class AccountVerificationScreen extends ConsumerStatefulWidget {
  const AccountVerificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountVerificationScreen> createState() => _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends ConsumerState<AccountVerificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final ExceptionService exceptionService = ExceptionService();
  final StorageService _storageService = StorageService();
  final ResponsiveService responsiveService = ResponsiveService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final controller = LoginController();


  bool _obscurePassword = true;
  bool _loading = false;

  Future<void> saveUserInfo(String name, String email) async {
    final StorageItem userName = StorageItem("userName", name);
    final StorageItem userEmail = StorageItem("userEmail", email);

    await _storageService.writeSecureData(userName);
    await _storageService.writeSecureData(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appLocalization = AppLocalizations.of(context)!;
    final pushNotifications = ref.watch(pushNotificationProvider);

    // for unverified users
    final registrationController = ref.watch(registrationControllerProvider);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AlcanciaToolbar(state: StateToolbar.logoLetters, logoHeight: screenHeight / 12, toolbarHeight: screenHeight / 11,),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        appLocalization.labelVerifyYourAccount,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          appLocalization.labelVerifyYourAccountDescription
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Column(
                        children: [
                          LabeledTextFormField(
                            controller: emailController,
                            labelText: appLocalization.labelEmail,
                            inputType: TextInputType.emailAddress,
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return appLocalization
                                    .errorRequiredField;
                              } else {
                                return value.isValidEmail()
                                    ? null
                                    : appLocalization
                                    .errorEmailFormat;
                              }
                            },
                          ),
                          SizedBox(height: responsiveService.getHeightPixels(16, screenHeight),),
                          LabeledTextFormField(
                            controller: passwordController,
                            labelText: appLocalization.labelPassword,
                            obscure: _obscurePassword,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Icon(_obscurePassword
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_fill),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return appLocalization
                                    .errorRequiredField;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    if (_loading) ... [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ] else ... [
                      AlcanciaButton(
                        color: alcanciaLightBlue,
                        width: double.infinity,
                        height: responsiveService.getHeightPixels(
                            64, screenHeight),
                        buttonText: appLocalization.buttonVerifyAccount,
                        onPressed: () async {
                          await _login(
                              pushNotifications,
                              registrationController);
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(
      PushNotificationProvider pushNotifications,
      RegistrationController registrationController) async {
    try {
      setState(() {
        _loading = true;
      });
      final data = await controller.signIn(
          emailController.text, passwordController.text);
      context.push("/mfa", extra: data);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      final notVerified = e.toString().contains("UserNotConfirmedException");
      if (notVerified) {
        registrationController.resendVerificationCode(emailController.text);
        context.push("/otp", extra: OTPDataModel(email: emailController.text));
      } else {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
