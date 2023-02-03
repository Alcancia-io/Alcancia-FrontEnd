import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';

class AlcanciaContainer extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? width;
  final double? height;
  final double? borderRadius;
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
    this.borderRadius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)), color: color),
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
