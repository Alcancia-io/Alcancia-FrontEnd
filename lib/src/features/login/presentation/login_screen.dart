import 'package:alcancia/src/features/registration/provider/registration_controller_provider.dart';
import 'package:alcancia/src/features/registration/provider/timer_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_link.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
import 'package:alcancia/src/shared/models/storage_item.dart';
import 'package:alcancia/src/shared/provider/push_notifications_provider.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/features/login/data/login_mutation.dart';

final rememberEmailProvider = StateProvider.autoDispose<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

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
  final obscurePasswordProvider = StateProvider.autoDispose<bool>((ref) => true);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? userName;
  var loginUserInput;

  saveUserInfo(String name, String email) async {
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

  saveToken(String token) async {
    final StorageItem storageItem = StorageItem("token", token);
    await _storageService.writeSecureData(storageItem);
  }

  setLoginInputFields({required String deviceToken}) {
    loginUserInput = {"email": emailController.text, "password": passwordController.text, "deviceToken": deviceToken};
  }

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    final rememberMe = ref.watch(rememberEmailProvider);
    final appLocalization = AppLocalizations.of(context)!;
    final obscurePassword = ref.watch(obscurePasswordProvider);
    final pushNotifications = ref.watch(pushNotificationProvider);
    final timer = ref.watch(timerProvider);

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
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AlcanciaLogo(
                        height: size.height / 8,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: responsiveService.getHeightPixels(50, screenHeight),
                              top: responsiveService.getHeightPixels(40, screenHeight)),
                          child: Text(
                            '¡Hola!\nBienvenido ${userName ?? ""}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                          ),
                        ),
                        Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  if (userName == null)
                                    Column(
                                      children: [
                                        LabeledTextFormField(
                                          controller: emailController,
                                          labelText: appLocalization.email,
                                          inputType: TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return appLocalization.errorRequiredField;
                                            } else {
                                              return value.isValidEmail() ? null : appLocalization.errorEmailFormat;
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: responsiveService.getHeightPixels(6, screenHeight),
                                              top: responsiveService.getHeightPixels(6, screenHeight)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 25,
                                                child: Checkbox(
                                                    value: rememberMe,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    onChanged: (value) {
                                                      ref.read(rememberEmailProvider.notifier).state = value!;
                                                    }),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(left: 8.0),
                                                child: Text("Recordar usuario"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  LabeledTextFormField(
                                    controller: passwordController,
                                    labelText: appLocalization.password,
                                    obscure: obscurePassword,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        ref.read(obscurePasswordProvider.notifier).state = !obscurePassword;
                                      },
                                      child: Icon(obscurePassword ? CupertinoIcons.eye : CupertinoIcons.eye_fill),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return appLocalization.errorRequiredField;
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: responsiveService.getHeightPixels(6, screenHeight),
                                        top: responsiveService.getHeightPixels(6, screenHeight)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CupertinoButton(
                                            child: Row(
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.only(right: 4.0),
                                                  child: Icon(CupertinoIcons.question_circle),
                                                ),
                                                Text("Olvidé mi contraseña"),
                                              ],
                                            ),
                                            onPressed: () async {
                                              if (emailController.text.isNotEmpty) {
                                                final StorageItem userEmail = StorageItem("userEmail", emailController.text);
                                                await _storageService.writeSecureData(userEmail);
                                                context.pushNamed('forgot-password');
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Mutation(
                                options: MutationOptions(
                                    document: gql(loginMutation),
                                    onCompleted: (dynamic resultData) {
                                      if (resultData != null) {
                                        final token = resultData["login"]["access_token"];
                                        final userName = resultData["login"]["user"]["name"];
                                        final userEmail = resultData["login"]["user"]["email"];
                                        final userPhone = resultData["login"]["user"]["phoneNumber"];
                                        if (rememberMe) {
                                          saveUserInfo(userName, userEmail);
                                        }
                                        saveToken(token);
                                        timer.setPresetMinuteTime(1, add: false);
                                        timer.onResetTimer();
                                        timer.onStartTimer();
                                        context.push("/mfa",
                                            extra: LoginDataModel(
                                                email: userEmail,
                                                password: passwordController.text,
                                                phoneNumber: userPhone));
                                      }
                                    },
                                    onError: (error) {
                                      final notVerified =
                                          error!.graphqlErrors.first.message.contains("UserNotConfirmedException");
                                      if (notVerified) {
                                        registrationController.resendVerificationCode(emailController.text);
                                        timer.setPresetMinuteTime(1, add: false);
                                        timer.onResetTimer();
                                        timer.onStartTimer();
                                        context.push("/otp", extra: OTPDataModel(email: emailController.text));
                                      }
                                    }),
                                builder: (
                                  MultiSourceResult<Object?> Function(Map<String, dynamic>, {Object? optimisticResult})
                                      runMutation,
                                  QueryResult<Object?>? result,
                                ) {
                                  if (result != null) {
                                    if (result.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (result.hasException) {
                                      var exception = exceptionService.handleException(result.exception);
                                      return Column(
                                        children: [
                                          AlcanciaButton(
                                            width: responsiveService.getWidthPixels(304, screenWidth),
                                            height: responsiveService.getHeightPixels(64, screenHeight),
                                            buttonText: "Iniciar sesión",
                                            onPressed: () async {
                                              final token = await pushNotifications.messaging.getToken();
                                              setLoginInputFields(deviceToken: token ?? "");
                                              runMutation(
                                                {"loginUserInput": loginUserInput},
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              exception!,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                  return Column(
                                    children: [
                                      AlcanciaButton(
                                        color: alcanciaLightBlue,
                                        width: responsiveService.getWidthPixels(304, screenWidth),
                                        height: responsiveService.getHeightPixels(64, screenHeight),
                                        buttonText: "Iniciar sesión",
                                        onPressed: () async {
                                          final token = await pushNotifications.messaging.getToken();
                                          setLoginInputFields(deviceToken: token ?? "");
                                          runMutation(
                                            {"loginUserInput": loginUserInput},
                                          );
                                        },
                                      ),
                                      if (userName != null) ...[
                                        Padding(
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
                                                  "Iniciar sesión con ",
                                                  style: txtTheme.bodyText1,
                                                ),
                                                const AlcanciaLink(
                                                  text: "otra cuenta",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text("No tengo cuenta."),
                                            CupertinoButton(
                                              child: const Text(
                                                "Registrarme",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                context.push("/registration");
                                              },
                                            ),
                                          ],
                                        ),
                                      ]
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
}
