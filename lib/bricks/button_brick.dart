import 'package:flutter/material.dart';

import '../app_text.dart';
import '../child_protection.dart';
import '../config.dart';
import 'text_brick.dart';

class ButtonBrick extends TextBrick {
  final bool hasChildProtection;
  final VoidCallback onPress;

  const ButtonBrick({
    super.key,
    required super.text,
    required this.hasChildProtection,
    super.scale,
    super.wrapWords,
    super.minFontSize,
    super.maxFontSize,
    super.maxLines,
    required this.onPress,
  });

  @override
  TextStyle get style => C.defaultButtonTextStyle;

  @override
  Widget build(BuildContext context) {
    final padding = C.defaultFontSizeRelative / 2 * scale;
    final innerPadding = EdgeInsets.symmetric(
          vertical: padding / 3,
          horizontal: padding,
        ) *
        scale;
    final outerPadding = innerPadding * 2;

    final child = Padding(
      padding: innerPadding,
      child: AppText(
        text,
        scale: scale,
        wrapWords: wrapWords,
        minFontSize: minFontSize,
        maxFontSize: maxFontSize,
        maxLines: maxLines,
      ),
    );

    final act = hasChildProtection
        ? () => ChildProtection(onCorrectTap: onPress).onTapEvent(context)
        : onPress;

    return Padding(
      padding: outerPadding,
      child: ElevatedButton(
        onPressed: act,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(innerPadding),
        ),
        child: child,
      ),
    );
  }
}
