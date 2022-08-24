import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlcanciaLogo extends StatelessWidget {
  const AlcanciaLogo({Key? key, this.height}) : super(key: key);
  final double? height;

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      isDarkMode
          ? "lib/src/resources/images/icon_alcancia_dark_no_letters.svg"
          : "lib/src/resources/images/icon_alcancia_light_no_letters.svg",
      height: height,
    );
  }
}
