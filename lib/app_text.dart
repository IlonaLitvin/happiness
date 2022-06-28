import 'package:auto_size_text/auto_size_text.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:flutter/material.dart';

import 'config.dart';

@immutable
class AppText extends StatelessWidget {
  final String data;
  final double scale;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final int? maxLines;
  final bool? wrapWords;
  final double? minFontSize;
  final double? maxFontSize;

  const AppText(
    this.data, {
    super.key,
    double? scale,
    this.textAlign,
    this.textStyle,
    this.maxLines,
    this.wrapWords,
    this.minFontSize,
    this.maxFontSize,
  })  : assert(scale == null || scale > 0),
        scale = scale ?? 1.0;

  @override
  Widget build(BuildContext context) {
    final scaledFontSize =
        (textStyle?.fontSize ?? C.defaultFontSizeRelative) * scale;
    final scaledMinFontSize =
        (minFontSize ?? C.defaultFontSizeRelative) * scale;
    var scaledMaxFontSize =
        maxFontSize == null ? double.infinity : maxFontSize! * scale;
    if (!scale.isNearOne) {
      scaledMaxFontSize = scaledFontSize;
    }

    return AutoSizeText(
      data,
      key: key,
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle?.copyWith(fontSize: scaledFontSize.roundToDouble()),
      maxLines: maxLines,
      wrapWords: wrapWords ?? true,
      minFontSize: scaledMinFontSize.roundToDouble(),
      maxFontSize: scaledMaxFontSize.roundToDouble(),
    );
  }
}
