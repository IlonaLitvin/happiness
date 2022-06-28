import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/effects/color_to_grey.dart';
import 'package:happiness/effects/scale_in_out.dart';
import 'package:happiness/effects/weffect.dart';
import 'package:happiness/state_machine_data.dart';

import 'init_test_environment.dart';

void main() {
  initTestEnvironment();

  group('FSM WDirector', () {
    test('with one effect', () {
      const o = WDirector('idle', [ColorToGrey()]);
      expect(o.stateName, 'idle');
      expect(o.effectList, const [ColorToGrey()]);

      final oJson = o.toJson();
      final oRecovered = WDirector.fromJson(oJson);

      expect(o.stateName, oRecovered.stateName);
      expect(o.effectList, oRecovered.effectList);
      expect(oJson, oRecovered.toJson());
    });

    test('with empty list effect', () {
      _verify('idle', const []);
    });

    test('with 1 effect in the list', () {
      _verify('idle', const [ColorToGrey()]);
    });

    test('with 2 effect in the list', () {
      _verify('idle', const [
        ScaleInOut(duration: 0.5, scale: 1.2),
        ColorToGrey(),
      ]);
    });
  });
}

void _verify(String stateName, List<WEffect> effectList) {
  final o = WDirector(stateName, effectList);
  expect(o.stateName, stateName);
  expect(o.effectList, effectList);

  final oJson = o.toJson();
  final oRecovered = WDirector.fromJson(oJson);

  expect(o.stateName, oRecovered.stateName);
  expect(o.effectList, oRecovered.effectList);
  expect(oJson, oRecovered.toJson());
}
