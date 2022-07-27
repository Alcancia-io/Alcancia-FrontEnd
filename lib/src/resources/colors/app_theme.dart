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
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: alcanciaFieldLight,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      unselectedWidgetColor: alcanciaLightBlue,
      checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(alcanciaLightBlue),
          checkColor: MaterialStateProperty.all(Colors.white)),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
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
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: alcanciaFieldDark,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      unselectedWidgetColor: alcanciaLightBlue,
      checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(alcanciaLightBlue),
          checkColor: MaterialStateProperty.all(Colors.white)),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        scaffoldBackgroundColor: alcanciaBgDark,
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: 'Gotham'),
        ),
      ),
    );
  }
}
