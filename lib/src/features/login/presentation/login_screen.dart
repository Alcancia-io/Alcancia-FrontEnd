import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/models/storage_item.dart';
import 'package:alcancia/src/shared/provider/user.dart';
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
import 'package:intl/intl.dart';

final rememberEmailProvider = StateProvider.autoDispose<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final StorageService _storageService = StorageService();

  final obscurePasswordProvider =
      StateProvider.autoDispose<bool>((ref) => true);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var loginUserInput;

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
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final size = MediaQuery.of(context).size;
    final rememberMe = ref.watch(rememberEmailProvider);
    final appLocalization = AppLocalizations.of(context)!;
    final obscurePassword = ref.watch(obscurePasswordProvider);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¡Hola!\nBienvenido',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35),
                        ),
                        Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  LabeledTextFormField(
                                    controller: emailController,
                                    labelText: appLocalization.email,
                                    inputType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return appLocalization
                                            .errorRequiredField;
                                      } else {
                                        return value.isValidEmail()
                                            ? null
                                            : appLocalization.errorEmailFormat;
                                      }
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: Checkbox(
                                            value: rememberMe,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            onChanged: (value) {
                                              ref
                                                  .read(rememberEmailProvider
                                                      .notifier)
                                                  .state = value!;
                                            }),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text("Recordar usuario"),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CupertinoButton(
                                          child: Row(
                                            children: const [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 4.0),
                                                child: Icon(CupertinoIcons
                                                    .question_circle),
                                              ),
                                              Text("Olvidé mi contraseña"),
                                            ],
                                          ),
                                          onPressed: () {
                                            // TODO: Forgot Password navigation
                                          }),
                                    ],
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
                                      var userJson =
                                          resultData["login"]["user"];
                                      userJson["dob"] = "12/12/2022";
                                      print(userJson);
                                      var user = User.fromJSON(userJson);

                                      saveToken(token);
                                      context.go("/homescreen/0");
                                      // save user

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
                                            buttonText: "Iniciar sesión",
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
                                  return AlcanciaButton(
                                    buttonText: "Iniciar sesión",
                                    onPressed: () {
                                      setLoginInputFields();
                                      runMutation(
                                        {"loginUserInput": loginUserInput},
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("No tengo cuenta."),
                                CupertinoButton(
                                    child: const Text(
                                      "Registrarme",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      context.push("/registration");
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
