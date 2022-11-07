import 'package:flutter/material.dart';

SnackBar AlcanciaSnackBar(BuildContext context, String string) {
  return SnackBar(
    content: Text(
      string,
      style: Theme.of(context).textTheme.bodyText2,
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
    duration: Duration(seconds: 5),
  );
}