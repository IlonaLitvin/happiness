import 'package:dart_helpers/dart_helpers.dart';
import 'package:flame/components.dart';
import 'package:flutter_flame_helpers/flutter_flame_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/welements/welement_source.dart';

import 'init_test_environment.dart';

void main() {
  initTestEnvironment();

  group('JsonSerializable', () {
    test('plain welement', () {
      final o = S(
        name: 'bushes_right',
        isVisible: false,
        position: Vector2(1234, 5678),
        anchor: Anchor.bottomRight,
        scale: 1.23,
        isMute: true,
      );
      final oString = o.sjson;
      final oRecovered = WelementSource.fromString(oString);

      expect(o.name, oRecovered.name);
      expect(o.isVisible, oRecovered.isVisible);
      expect(o.position, oRecovered.position);
      expect(o.anchor.s, oRecovered.anchor.s);
      expect(o.scale, oRecovered.scale);
      expect(o.isMute, oRecovered.isMute);
      expect(oString, oRecovered.sjson);
    });

    test('welement with group', () {
      final o = S(
        name: 'grouped welement',
      );
      final oString = o.sjson;
      final oRecovered = WelementSource.fromString(oString);

      expect(o.name, oRecovered.name);
      //expect(o.group.first.anchor, oRecovered.group.first.anchor,
      //    reason: o.group.first.anchor.s);
      expect(oString, oRecovered.sjson);
    });
  });
}
