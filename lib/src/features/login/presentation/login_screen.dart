import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final rememberEmailProvider = StateProvider.autoDispose<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);

  final obscurePassword = StateProvider.autoDispose<bool>((ref) => true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final rememberMe = ref.watch(rememberEmailProvider);
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
                        child: Column(children: [
                          LabeledTextFormField(
                              controller: TextEditingController(),
                              labelText: "Correo electrónico",
                              inputType: TextInputType.emailAddress),
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
                                padding: EdgeInsets.only(
                                    left: 8.0),
                                child: Text("Recordar usuario"),
                              ),
                            ],
                          ),
                          LabeledTextFormField(
                            controller: TextEditingController(),
                            labelText: "Contraseña",
                            obscure: true,
                            suffixIcon: const Icon(true
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //TODO: Question mark icon
                              //Icon(Icons.question_mark, size: 16,),
                              CupertinoButton(
                                  child: Text("Olvidé mi contraseña"),
                                  onPressed: () {
                                    // TODO: Forgot Password navigation
                                  })
                            ],
                          ),
                        ]),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AlcanciaButton(() {}, "Iniciar sesión"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("No tengo cuenta."),
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
