import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class AlcanciaTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: alcanciaBgLight,
      primaryColor: alcanciaBgLight,
      cardColor: alcanciaBgLight,
      backgroundColor: alcanciaBgLight,
      fontFamily: 'Gotham',
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle:
              MaterialStateProperty.all(const TextStyle(fontFamily: 'Gotham')),
        ),
      ),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        // primaryColor: alcanciaBgLight,
        scaffoldBackgroundColor: alcanciaBgLight,
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: 'Gotham'),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: alcanciaBgDark,
      primaryColor: alcanciaBgDark,
      cardColor: alcanciaBgDark,
      backgroundColor: alcanciaBgDark,
      fontFamily: "Gotham",
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle:
              MaterialStateProperty.all(const TextStyle(fontFamily: 'Gotham')),
        ),
      ),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        // primaryColor: alcanciaBgDark,
        scaffoldBackgroundColor: alcanciaBgDark,
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: 'Gotham'),
        ),
      ),
    );
  }
}
