// Flutter package imports:
import 'package:alcancia/src/features/registration/model/registration_controller.dart';
// Relative imports:
import 'package:alcancia/src/features/registration/provider/registration_controller_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/login/login_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/components/alcancia_link.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
import 'package:alcancia/src/shared/models/storage_item.dart';
import 'package:alcancia/src/shared/provider/push_notifications_provider.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
// Other package imports:
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    readUserInfo();
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

  String? userName;

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _loading = false;

  Future<void> saveUserInfo(String name, String email) async {
    final StorageItem userName = StorageItem("userName", name);
    final StorageItem userEmail = StorageItem("userEmail", email);

    await _storageService.writeSecureData(userName);
    await _storageService.writeSecureData(userEmail);
  }

  readUserInfo() async {
    var userEmail = await _storageService.readSecureData("userEmail");
    userName = await _storageService.readSecureData("userName");

    if (userEmail != null) {
      emailController.text = userEmail;
    }
    if (userName != null) {
      setState(() {});
    }
  }

  Future<void> saveToken(String token) async {
    final StorageItem storageItem = StorageItem("token", token);
    await _storageService.writeSecureData(storageItem);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final appLocalization = AppLocalizations.of(context)!;
    final pushNotifications = ref.watch(pushNotificationProvider);

    // for unverified users
    final registrationController = ref.watch(registrationControllerProvider);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AlcanciaLogo(
                          height: screenHeight / 8,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: responsiveService.getHeightPixels(50, screenHeight),
                          top: responsiveService.getHeightPixels(40, screenHeight)),
                      child: Text(
                        appLocalization.labelHelloWelcome(userName ?? ""),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                    ),
                    Column(
                      children: [
                        if (userName == null)
                          Column(
                            children: [
                              LabeledTextFormField(
                                controller: emailController,
                                labelText: appLocalization.labelEmail,
                                inputType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appLocalization.errorRequiredField;
                                  } else {
                                    return value.isValidEmail() ? null : appLocalization.errorEmailFormat;
                                  }
                                },
                              ),
                              _buildRememberMe(appLocalization, screenHeight),
                            ],
                          ),
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
                            child: Icon(_obscurePassword ? CupertinoIcons.eye : CupertinoIcons.eye_fill),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalization.errorRequiredField;
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: responsiveService.getHeightPixels(6, screenHeight),
                            top: responsiveService.getHeightPixels(6, screenHeight),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CupertinoButton(
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4.0),
                                      child: Icon(CupertinoIcons.question_circle),
                                    ),
                                    Text(appLocalization.labelForgotPassword),
                                  ],
                                ),
                                onPressed: () async {
                                  await _forgotPassword(appLocalization);
                                },
                              ),
                            ],
                          ),
                        ),
                        if (_loading) ...[
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ] else ...[
                          AlcanciaButton(
                            color: alcanciaLightBlue,
                            width: responsiveService.getWidthPixels(304, screenWidth),
                            height: responsiveService.getHeightPixels(64, screenHeight),
                            buttonText: appLocalization.buttonLogIn,
                            onPressed: () async {
                              await _login(pushNotifications, registrationController);
                            },
                          ),
                        ],
                        _buildFooter(appLocalization: appLocalization),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(PushNotificationProvider pushNotifications, RegistrationController registrationController) async {
    try {
      setState(() {
        _loading = true;
      });
      final deviceToken = await pushNotifications.messaging.getToken();
      final data = await controller.login(emailController.text, passwordController.text, deviceToken ?? "");
      await saveToken(data.token);
      if (_rememberMe) {
        await saveUserInfo(data.name, data.email);
      }
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

  Future<void> _forgotPassword(appLocalization) async {
    if (emailController.text.isNotEmpty) {
      final StorageItem userEmail = StorageItem("userEmail", emailController.text);
      await _storageService.writeSecureData(userEmail);
      context.pushNamed('forgot-password');
    } else {
      Fluttertoast.showToast(
          msg: appLocalization.errorEmailRequired,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget _buildRememberMe(appLocalization, screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: responsiveService.getHeightPixels(6, screenHeight),
          top: responsiveService.getHeightPixels(6, screenHeight)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 25,
            child: Checkbox(
                value: _rememberMe,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(appLocalization.labelRememberUser),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter({required AppLocalizations appLocalization}) {
    final txtTheme = Theme.of(context).textTheme;
    if (userName != null) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 30,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              userName = null;
              emailController.text = "";
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appLocalization.labelLogInWith,
                style: txtTheme.bodyLarge,
              ),
              AlcanciaLink(
                text: appLocalization.buttonAnotherAccount,
              ),
            ],
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(appLocalization.labelNeedAccount),
          CupertinoButton(
            child: Text(
              appLocalization.buttonRegister,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              context.push("/registration");
            },
          ),
        ],
      );
    }
  }
}
