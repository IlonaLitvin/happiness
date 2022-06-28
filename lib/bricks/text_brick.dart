import 'package:flutter/material.dart';

import '../app_text.dart';
import '../config.dart';
import 'brick.dart';

class TextBrick extends Brick {
  final String text;
  final double scale;
  final bool? wrapWords;
  final double? minFontSize;
  final double? maxFontSize;
  final int? maxLines;
  final TextStyle? _style;

  TextStyle get style => _style ?? C.defaultTextStyle;

  const TextBrick({
    super.key,
    required this.text,
    double? scale,
    this.wrapWords,
    this.minFontSize,
    this.maxFontSize,
    this.maxLines,
    TextStyle? style,
  })  : assert(text.length > 0),
        scale = scale ?? 1.0,
        _style = style;

  factory TextBrick.fromJson(Map<String, dynamic> json) => TextBrick(
        text: json['text'] as String,
        scale: (json['scale'] ?? 1.0) as double,
        wrapWords: (json['wrapWords'] ?? false) as bool,
        minFontSize: json['minFontSize'] as double?,
        maxFontSize: json['maxFontSize'] as double?,
        maxLines: json['maxLines'] as int?,
      );

  TextBrick copyWith({
    String? text,
    double? scale,
    bool? wrapWords,
    double? minFontSize,
    double? maxFontSize,
    int? maxLines,
    TextStyle? style,
  }) =>
      TextBrick(
        key: key,
        text: text ?? this.text,
        scale: scale ?? this.scale,
        wrapWords: wrapWords ?? this.wrapWords,
        minFontSize: minFontSize ?? this.minFontSize,
        maxFontSize: maxFontSize ?? this.maxFontSize,
        maxLines: maxLines ?? this.maxLines,
        style: style ?? this.style,
      );

  @override
  Widget build(BuildContext context) =>
      AppText(text, scale: scale, textStyle: style);
}
