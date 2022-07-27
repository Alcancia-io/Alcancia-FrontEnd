import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/cupertino.dart';

class AlcanciaButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  // const AlcanciaButton({Key? key},) : super(key: key);
  const AlcanciaButton(this.onPressed, this.buttonText);

  @override
  Widget build(
    BuildContext context,
  ) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.07,
      child: CupertinoButton(
        onPressed: onPressed,
        color: alcanciaLightBlue,
        child: Text(buttonText,
            style: const TextStyle(fontSize: 15), textAlign: TextAlign.center),
      ),
    );
  }
}
