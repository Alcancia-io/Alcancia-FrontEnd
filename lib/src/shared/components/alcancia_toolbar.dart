import 'package:flutter/material.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';

enum StateToolbar { logoNoletters, logoLetters, titleIcon, profileTitleIcon }

class AlcanciaToolbar extends StatelessWidget {
  const AlcanciaToolbar({
    Key? key,
    this.title,
    required this.state,
    this.userName,
    required this.logoHeight,
  }) : super(key: key);

  final String? title;
  final String? userName;
  final double logoHeight;
  /*
  logo-noletters
  logo-letters
  title-icon
  profile-title-icon
   */
  final StateToolbar state;
  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    switch (state) {
      case StateToolbar.logoNoletters:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlcanciaLogo(
              height: logoHeight,
            )
          ],
        );
      case StateToolbar.logoLetters:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlcanciaLogo(
              letters: true,
              height: logoHeight,
            ),
          ],
        );
      case StateToolbar.titleIcon:
        return Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "$title",
                  style: txtTheme.subtitle1,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Transform(
                  transform: Matrix4.translationValues(0, -10, 0),
                  child: AlcanciaLogo(
                    height: logoHeight,
                  ),
                ),
              ),
            ],
          ),
        );
      case StateToolbar.profileTitleIcon:
        return Container(
          padding: const EdgeInsets.only(bottom: 24, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "lib/src/resources/images/profile.png",
                    width: 38,
                    height: 38,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      "Hola, $userName",
                      style: txtTheme.subtitle1,
                    ),
                  ),
                ],
              ),
              AlcanciaLogo(
                height: logoHeight,
              ),
            ],
          ),
        );
      default:
        return const Text("Default");
    }
  }
}
