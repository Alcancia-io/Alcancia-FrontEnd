import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color alcanciaDarkBlue = Color(0xFF1F318C);
const Color alcanciaMidBlue = Color(0xFF3554C4);
const Color alcanciaLightBlue = Color(0xFF4E76E5);
const Color alcanciaBgDark = Color(0xFF000F2B);
const Color alcanciaBgLight = Color(0xFFFFFFFF);
const Color alcanciaCardDark = Color(0xFF071737);
const Color alcanciaCardLight = Color(0xFFFFFFFF);
const Color alcanciaFieldDark = Color(0xFF0F2346);
const Color alcanciaFieldLight = Color(0xFFF5F5F5);
const Color alcanciaCardDark2 = Color.fromRGBO(15, 35, 70, 0.47);
const Color alcanciaCardLight2 = Color.fromRGBO(245, 245, 245, 1);

const CupertinoDynamicColor alcanciaWhiteBlack = CupertinoDynamicColor.withBrightness(color: CupertinoColors.white, darkColor: CupertinoColors.black);

const alcanciaWelcomeGradient = [
  Color(0xffffffff),
  Color(0xff4E76E5)
];
const alcanciaWelcomeGradientDark = [
  Color(0xff0F2346),
  Color(0xff1C3466),
  Color(0xff476DD3),
  Color(0xff4368C9),
  Color(0xff395AB0),
  Color(0xff4E76E5)
];

getPattern(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  if (isDark) {
    return alcanciaWelcomeGradientDark;
  } else {
    return alcanciaWelcomeGradient;
  }
}