import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class AlcanciaTheme {
  static const TextTheme _textTheme = TextTheme(
      headline1: TextStyle(fontWeight: FontWeight.w700, fontSize: 35),
      headline2: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      subtitle1: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      subtitle2: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
      bodyText1: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
      bodyText2: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
      caption: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
      button: TextStyle(fontWeight: FontWeight.w400, fontSize: 18));

  static ThemeData get lightTheme {
    return ThemeData(
      canvasColor: alcanciaBgLight,
      brightness: Brightness.light,
      scaffoldBackgroundColor: alcanciaBgLight,
      primaryColor: alcanciaBgLight,
      cardColor: alcanciaBgLight,
      backgroundColor: alcanciaBgLight,
      fontFamily: 'Gotham',
      textTheme: _textTheme,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle:
              MaterialStateProperty.all(const TextStyle(fontFamily: 'Gotham')),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
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
      canvasColor: alcanciaBgDark,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: alcanciaBgDark,
      primaryColor: alcanciaBgDark,
      cardColor: alcanciaBgDark,
      backgroundColor: alcanciaBgDark,
      fontFamily: "Gotham",
      textTheme: _textTheme,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle:
              MaterialStateProperty.all(const TextStyle(fontFamily: 'Gotham')),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
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
