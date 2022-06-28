import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as oktoast;

import 'config.dart';

class AppToast extends oktoast.OKToast {
  const AppToast({super.key, required super.child})
      : super(
          //textStyle: C.defaultButtonTextStyle,
          backgroundColor: C.defaultButtonBackgroundColor,
        );
}

oktoast.ToastFuture showAppToast(
  String msg, {
  Duration? duration = const Duration(seconds: 3),
}) =>
    oktoast.showToast(
      msg,
      duration: duration,
      textPadding: EdgeInsets.all(C.defaultFontSizeRelative * 1.8),
      radius: C.defaultFontSizeRelative / 2,
      textStyle: C.defaultButtonTextStyle.copyWith(
        fontSize: C.defaultFontSizeRelative * 1.2,
      ),
    );
