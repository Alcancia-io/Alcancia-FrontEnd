import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlcanciaLogo extends StatelessWidget {
  const AlcanciaLogo({Key? key, this.height, this.letters}) : super(key: key);
  final double? height;
  final bool? letters;

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (letters != null && letters == true) {
      return SvgPicture.asset(
        isDarkMode
            ? "lib/src/resources/images/icon_alcancia_dark.svg"
            : "lib/src/resources/images/icon_alcancia_light.svg",
        height: height,
      );
    } else {
      return SvgPicture.asset(
        isDarkMode
            ? "lib/src/resources/images/icon_alcancia_dark_no_letters.svg"
            : "lib/src/resources/images/icon_alcancia_light_no_letters.svg",
        height: height,
      );
    }
  }
}
