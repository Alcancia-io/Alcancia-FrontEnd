import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'alcancia_button.dart';

class AlcanciaActionDialog extends StatelessWidget {
  const AlcanciaActionDialog({
    Key? key,
    required this.child,
    required this.acceptText,
    required this.cancelText,
    this.acceptColor,
    this.cancelColor,
    required this.acceptAction,
  }) : super(key: key);

  final Widget child;
  final String acceptText;
  final Color? acceptColor;
  final Color? cancelColor;
  final Function() acceptAction;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: child,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AlcanciaButton(
                  buttonText: acceptText,
                  width: 308,
                  height: 40,
                  color: acceptColor,
                  onPressed: () {
                    acceptAction();
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AlcanciaButton(
                  buttonText: cancelText,
                  width: 308,
                  height: 40,
                  color: cancelColor ?? alcanciaLightBlue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
