import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlcanciaButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final double? fontSize;
  final double? height;
  final double? width;
  final Color? color;
  final Color? foregroundColor;
  final bool? rounded;
  final BorderSide? side;
  final Widget? icon;
  final EdgeInsetsGeometry padding;

  const AlcanciaButton({super.key,
    required this.buttonText,
    this.fontSize,
    required this.onPressed,
    this.height,
    this.width,
    this.color = const Color(0xFF4E76E5),
    this.foregroundColor = const Color(0xFF4E76E5),
    this.rounded,
    this.side,
    this.icon,
    this.padding = const EdgeInsets.only(right: 4, left: 4),
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
            side: side,
            foregroundColor: foregroundColor,
            backgroundColor: color,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          icon: icon ?? SvgPicture.asset("lib/src/resources/images/plus_icon.svg"),
          label: Text(
            buttonText,
            style: TextStyle(
              fontSize: fontSize ?? 13,
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
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(fontSize: fontSize ?? 15),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
