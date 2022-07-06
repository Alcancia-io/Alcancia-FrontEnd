import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        body: Column(
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
          ],
        ),
      ),
    );
  }
}
