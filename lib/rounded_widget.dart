import 'package:flutter/material.dart' hide Card;

import '../config.dart';

class RoundedWidget extends StatelessWidget {
  final double topRightMultiplier;
  final double bottomRightMultiplier;
  final double topLeftMultiplier;
  final double bottomLeftMultiplier;

  final Color color;
  final double widthMultiplier;

  final EdgeInsets paddingMultiplier;

  final Widget child;

  final VoidCallback? onPressed;

  static double get defaultRadius => C.defaultFontSizeRelative;

  double get topRight => defaultRadius * topRightMultiplier;

  double get bottomRight => defaultRadius * bottomRightMultiplier;

  double get topLeft => defaultRadius * topLeftMultiplier;

  double get bottomLeft => defaultRadius * bottomLeftMultiplier;

  static double get defaultWidth => C.defaultFontSizeRelative / 12;

  double get width => defaultWidth * widthMultiplier;

  static double get defaultPadding => C.defaultFontSizeRelative / 2;

  EdgeInsets get padding => EdgeInsets.only(
        right: defaultPadding * paddingMultiplier.right,
        left: defaultPadding * paddingMultiplier.left,
        top: defaultPadding * paddingMultiplier.top,
        bottom: defaultPadding * paddingMultiplier.bottom,
      );

  static double get defaultWidthWithoutContent => defaultPadding * 2;

  static double get defaultHeightWithoutContent => defaultPadding * 2;

  const RoundedWidget({
    super.key,
    required this.child,
    this.topRightMultiplier = 1.0,
    this.topLeftMultiplier = 1.0,
    this.bottomRightMultiplier = 1.0,
    this.bottomLeftMultiplier = 1.0,
    this.color = Colors.white,
    this.widthMultiplier = 1.0,
    this.paddingMultiplier = const EdgeInsets.all(1.0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => onPressed == null
      ? _buildImage(context)
      : InkWell(
          onTap: onPressed,
          child: _buildImage(context),
        );

  Widget _buildImage(BuildContext context) => Padding(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRight),
            bottomRight: Radius.circular(bottomRight),
            topLeft: Radius.circular(topLeft),
            bottomLeft: Radius.circular(bottomLeft),
          ),
          child: child,
        ),
      );
}
