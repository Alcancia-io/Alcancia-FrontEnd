import 'package:flutter/cupertino.dart';
import 'package:alcancia/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var pattern = getPattern(isDarkMode);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: pattern)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SvgPicture.asset(isDarkMode
                  ? "assets/images/icon_alcancia_dark.svg"
                  : "assets/images/icon_alcancia_light.svg",
                  width: 96),
              Transform(
                transform: Matrix4.translationValues(0, 30, 0),
                child: const Image(
                    image: AssetImage("assets/images/welcome_image.png")),
              ),
              Expanded(
                  child: Container(
                width: size.width,

                decoration:  BoxDecoration(
                  color: Theme.of(context).primaryColor,

                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(33),
                        topRight: Radius.circular(33)
                    )


                ),
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Descubre una nueva forma de ahorrar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Construye tu portafolio de ahorro basado en crypto",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ),
                      const Spacer(),
                      CupertinoButton.filled(
                          child: const Text("Registrate"),
                          onPressed: () {},
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "¿Ya tienes cuenta?",
                            textAlign: TextAlign.center,
                          ),
                          CupertinoButton(
                              child: const Text(
                                "Inicia sesión",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold
                                    ),
                              ),
                              onPressed: () {}),
                        ],
                      )
                    ],
                  ),
                )),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
