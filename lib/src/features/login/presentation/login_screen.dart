import 'package:alcancia/src/features/registration/provider/timer_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_link.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:alcancia/src/shared/models/storage_item.dart';
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

  final StorageService _storageService = StorageService();
  final ResponsiveService responsiveService = ResponsiveService();
  String? userName;

  final obscurePasswordProvider =
      StateProvider.autoDispose<bool>((ref) => true);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  setLoginInputFields() {
    loginUserInput = {
      "email": emailController.text,
      "password": passwordController.text
    };
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
    final timer = ref.watch(timerProvider);
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
                      child: AlcanciaToolbar(
                        state: StateToolbar.logoNoletters,
                        logoHeight: size.height / 8,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: responsiveService.getHeightPixels(
                                  50, screenHeight),
                              top: responsiveService.getHeightPixels(
                                  40, screenHeight)),
                          child: Text(
                            appLocalization.labelHelloWelcome(userName ?? ""),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
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
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: responsiveService
                                                  .getHeightPixels(
                                                      6, screenHeight),
                                              top: responsiveService
                                                  .getHeightPixels(
                                                      6, screenHeight)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 25,
                                                child: Checkbox(
                                                    value: rememberMe,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    onChanged: (value) {
                                                      ref
                                                          .read(
                                                              rememberEmailProvider
                                                                  .notifier)
                                                          .state = value!;
                                                    }),
                                              ),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(appLocalization.labelRememberUser),
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
                                    labelText: appLocalization.labelPassword,
                                    obscure: obscurePassword,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(obscurePasswordProvider
                                                .notifier)
                                            .state = !obscurePassword;
                                      },
                                      child: Icon(obscurePassword
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_fill),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return appLocalization
                                            .errorRequiredField;
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: responsiveService
                                            .getHeightPixels(6, screenHeight),
                                        top: responsiveService.getHeightPixels(
                                            6, screenHeight)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CupertinoButton(
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 4.0),
                                                  child: Icon(CupertinoIcons
                                                      .question_circle),
                                                ),
                                                Text(appLocalization.labelForgotPassword),
                                              ],
                                            ),
                                            onPressed: () {
                                              // TODO: Forgot Password navigation
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
                                      final token =
                                          resultData["login"]["access_token"];
                                      final userName =
                                          resultData["login"]["user"]["name"];
                                      final userEmail =
                                          resultData["login"]["user"]["email"];
                                      final userPhone =
                                      resultData["login"]["user"]["phoneNumber"];
                                      if (rememberMe) {
                                        saveUserInfo(userName, userEmail);
                                      }
                                      saveToken(token);
                                      timer.setPresetMinuteTime(1, add: false);
                                      timer.onResetTimer();
                                      timer.onStartTimer();
                                      context.push("/mfa", extra: LoginDataModel(email: userEmail, password: passwordController.text, phoneNumber: userPhone));
                                    }
                                  },
                                ),
                                builder: (
                                  MultiSourceResult<Object?> Function(
                                          Map<String, dynamic>,
                                          {Object? optimisticResult})
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
                                      return Column(
                                        children: [
                                          AlcanciaButton(
                                            width: responsiveService
                                                .getWidthPixels(
                                                    304, screenWidth),
                                            height: responsiveService
                                                .getHeightPixels(
                                                    64, screenHeight),
                                            buttonText: appLocalization.labelLogIn,
                                            onPressed: () {
                                              setLoginInputFields();
                                              runMutation(
                                                {
                                                  "loginUserInput":
                                                      loginUserInput
                                                },
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              result.exception!.graphqlErrors
                                                  .first.message,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
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
                                        width: responsiveService.getWidthPixels(
                                            304, screenWidth),
                                        height: responsiveService
                                            .getHeightPixels(64, screenHeight),
                                        buttonText: appLocalization.labelLogIn,
                                        onPressed: () {
                                          setLoginInputFields();
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(appLocalization.labelNeedAcount),
                                            CupertinoButton(
                                              child: const Text(
                                                appLocalization.labelRegister,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
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
