import 'package:flutter/material.dart' hide Card;

import '../../config.dart';

@immutable
class HeartBackground extends StatelessWidget {
  final double width;
  final double height;

  const HeartBackground({
    super.key,
    double? width,
    double? height,
  })  : width = width ?? double.infinity,
        height = height ?? double.infinity;

  @override
  Widget build(BuildContext context) => Image.asset(
        '${C.assetsFolder}/${C.assetsImagesFolder}/color_heart.webp',
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
}
