import 'package:flutter/material.dart';
import 'alcancia_button.dart';

class AlcanciaActionDialog extends StatelessWidget {
  const AlcanciaActionDialog({
    Key? key,
    required this.child,
    required this.acceptText,
    required this.cancelText,
    this.acceptColor,
    required this.acceptAction,
  }) : super(key: key);

  final Widget child;
  final String acceptText;
  final Color? acceptColor;
  final Function() acceptAction;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              AlcanciaButton(
                buttonText: acceptText,
                color: acceptColor,
                onPressed: () {
                  acceptAction();
                  Navigator.pop(context);
                },
              ),
              AlcanciaButton(
                buttonText: cancelText,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
