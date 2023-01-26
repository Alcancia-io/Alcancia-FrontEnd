import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';

class AlcanciaContainer extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? width;
  final double? height;
  final Color? color;
  final Widget child;

  final ResponsiveService responsiveService = ResponsiveService();

  AlcanciaContainer({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.width,
    this.height,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: color,
      height: height,
      width: width,
      padding: EdgeInsets.only(
        top: top != null ? responsiveService.getHeightPixels(top!, screenHeight) : 0,
        bottom: bottom != null ? responsiveService.getHeightPixels(bottom!, screenHeight) : 0,
        left: left != null ? responsiveService.getWidthPixels(left!, screenWidth) : 0,
        right: right != null ? responsiveService.getWidthPixels(right!, screenWidth) : 0,
      ),
      child: child,
    );
  }
}
