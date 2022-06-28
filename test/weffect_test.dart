import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/effects/color_to_grey.dart';

import 'init_test_environment.dart';

void main() {
  initTestEnvironment();

  group('JsonSerializable', () {
    test('ColorToGrey', () {
      const o = ColorToGrey(
        duration: 12,
        curve: Curves.ease,
      );
      final oJson = o.toJson();
      final oRecovered = ColorToGrey.fromJson(oJson);

      expect(o.name, oRecovered.name);
      expect(o.duration, oRecovered.duration);
      expect(o.curve, oRecovered.curve);
      expect(oJson, oRecovered.toJson());
    });
  });
}
