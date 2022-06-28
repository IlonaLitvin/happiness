import 'package:adaptive_ui/utils.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpers/flutter_helpers.dart';
import 'package:get_it/get_it.dart';

import 'active_localization.dart';
import 'audio_horn.dart';
import 'config.dart';
import 'welements/welement_order_counter.dart';

/// Service locator for managers and services.
final GetIt sl = GetIt.instance;

var _initialized = false;

void initServiceLocatorOnce(BuildContext context) {
  // adaptive UI can be initialize any times, it's ok
  if (isCorrectContext(context)) {
    AdaptiveUI().init(
      context: context,
      width: C.designSize.x,
      height: C.designSize.y,
    );
  }

  if (_initialized) {
    Fimber.w('Service locator already initialized. Skip it.');
    return;
  }

  _initialized = true;

  // should be first
  sl.registerSingleton(WelementOrderCounter());

  if (isCorrectContext(context)) {
    sl.registerSingleton(ActiveLocalization(context));
  }

  sl.registerSingleton(Config());

  sl.registerSingleton(AudioHorn());
}
