import 'package:flutter/material.dart';

SnackBar alcanciaSnackBar(BuildContext context, String string) {
  return SnackBar(
    content: Text(
      string,
      style: Theme.of(context).textTheme.bodyText2,
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
    duration: const Duration(seconds: 5),
  );
}
