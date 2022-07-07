import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: SvgPicture.asset(
                isDarkMode
                    ? "lib/src/resources/images/icon_alcancia_dark_no_letters.svg"
                    : "lib/src/resources/images/icon_alcancia_light_no_letters.svg",
                height: size.height / 8,
              ),
            ),
            Row(children: const [
              Text(
                '!Hola!\nBienvenido',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
            ]),
            Form(
              child: Column(children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Correo Electrónico'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                ),
              ]),
            ),
            AlcanciaButton(() {}, "Iniciar  sesión"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("No tengo cuenta."),
                Text(
                  "Registrarme",
                  style: TextStyle(decoration: TextDecoration.underline),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
