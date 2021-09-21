import 'package:flutter/material.dart';

class IconDecoration extends StatelessWidget {
  IconDecoration({
    this.child,
    this.colors,
    this.radius,
    this.tileMode,
    this.center,
    this.focal,
    this.stops,
    this.focalRadius,
    this.transform,
  });

  final Widget child;
  final List<Color> colors;
  final double radius;
  final TileMode tileMode;
  final AlignmentGeometry center;
  final AlignmentGeometry focal;
  final List<double> stops;
  final double focalRadius;
  final GradientTransform transform;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        // center: Alignment.center,
        center: center,
        // radius: 0.25,
        radius: radius,
        colors: colors,
        tileMode: tileMode,
        focal: focal,
        // stops: stops,
        // focalRadius: focalRadius,
        // transform: transform,
      ).createShader(bounds),
      child: child,
    );
  }
}
