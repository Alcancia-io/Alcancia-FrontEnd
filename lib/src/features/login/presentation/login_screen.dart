import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_text_field.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/features/login/data/login_mutation.dart';

final rememberEmailProvider = StateProvider.autoDispose<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);

  final obscurePassword = StateProvider.autoDispose<bool>((ref) => true);
  final loginUserInput = {"email": "A01209400@itesm.mx", "password": ""};

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final rememberMe = ref.watch(rememberEmailProvider);
    final appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    isDarkMode
                        ? "lib/src/resources/images/icon_alcancia_dark_no_letters.svg"
                        : "lib/src/resources/images/icon_alcancia_light_no_letters.svg",
                    height: size.height / 8,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '¡Hola!\nBienvenido',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                          ),
                        ],
                      ),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(children: [
                          LabeledTextFormField(
                            controller: emailController,
                            labelText: appLocalization.email,
                            inputType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return appLocalization.errorRequiredField;
                              } else {
                                return value.isValidEmail()
                                    ? null
                                    : appLocalization.errorEmailFormat;
                              }
                            },
                          ),
                          Text("this is the controller"),
                          Text(emailController.text),
                          Row(
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
                                      ref
                                          .read(rememberEmailProvider.notifier)
                                          .state = value!;
                                    }),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text("Recordar usuario"),
                              ),
                            ],
                          ),
                          LabeledTextFormField(
                            controller: TextEditingController(),
                            labelText: appLocalization.password,
                            obscure: true,
                            suffixIcon: const Icon(true
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return appLocalization.errorRequiredField;
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
                                        padding: EdgeInsets.only(right: 4.0),
                                        child: Icon(
                                            CupertinoIcons.question_circle),
                                      ),
                                      Text("Olvidé mi contraseña"),
                                    ],
                                  ),
                                  onPressed: () {
                                    // TODO: Forgot Password navigation
                                  }),
                            ],
                          )
                        ]),
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
                                  print("hola");
                                  print(resultData['login']['access_token']);
                                },
                              ),
                              builder: (
                                MultiSourceResult<Object?> Function(
                                        Map<String, dynamic>,
                                        {Object? optimisticResult})
                                    runMutation,
                                QueryResult<Object?>? result,
                              ) {
                                return AlcanciaButton(
                                  () => runMutation(
                                    {"loginUserInput": loginUserInput},
                                  ),
                                  "Iniciar sesión",
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
                                    //TODO: Register navigation
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
    );
  }
}
