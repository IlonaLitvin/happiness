import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/widgets.dart';
import 'package:happiness/service_locator.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

/// Call this method for all main tests.
void initTestEnvironment() {
  Fimber.plantTree(DebugTree.elapsed(useColors: true));

  // For correct run a single test from Android Studio by Ctrl+Shift+F10 and
  // all tests from terminal by `flutter test`.
  // \see https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('${Platform.pathSeparator}test')) {
    Directory.current = Directory.current.parent;
  }

  initServiceLocatorOnce(MockBuildContext());
}
