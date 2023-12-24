import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlatformBiometricIcon extends StatelessWidget {
  const PlatformBiometricIcon({super.key, this.size = 30, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SvgPicture.asset(
        'lib/src/resources/images/faceid.svg',
        colorFilter: ColorFilter.mode(
          color ?? (Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black),
          BlendMode.srcIn,
        ),
        height: size,
      );
    } else {
      return Icon(
        Icons.fingerprint_outlined,
        size: 40,
      );
    }
  }
}
