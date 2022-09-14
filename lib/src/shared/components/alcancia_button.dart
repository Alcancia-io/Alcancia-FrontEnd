import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlcanciaButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final double? height;
  final double? width;
  final Color? color;
  final bool? rounded;

  const AlcanciaButton({
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.width,
    this.color,
    this.rounded,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if (rounded != null) {
      return SizedBox(
        height: height,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.only(right: 4, left: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          icon: SvgPicture.asset("lib/src/resources/images/plus_icon.svg"),
          label: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4E76E5),
            ),
          ),
          onPressed: onPressed,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
