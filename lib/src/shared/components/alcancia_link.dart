import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class AlcanciaLink extends StatelessWidget {
  const AlcanciaLink({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: alcanciaLightBlue,
        fontSize: 15,
        decoration: TextDecoration.underline,
        decorationThickness: 4,
      ),
    );
  }
}
