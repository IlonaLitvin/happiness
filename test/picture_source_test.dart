import 'package:dart_helpers/dart_helpers.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_flame_helpers/flutter_flame_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/card_aware.dart';
import 'package:happiness/picture_helper.dart';
import 'package:happiness/picture_source.dart';
import 'package:happiness/state_machine_data.dart';
import 'package:happiness/welements/welement_source.dart';
import 'package:mockito/mockito.dart';

import 'init_test_environment.dart';

class MockBuildContext extends Mock implements BuildContext {
  @override
  Widget get widget => Container();
}

void main() {
  initTestEnvironment();

  group('JsonSerializable', () {
    final aware = CardAware(MockBuildContext());

    test('demo picture', () async {
      const p = PictureHelper(4100, 3075);
      final o = PictureSource(
        aspectSize: aware.preferredScreenAspectSize(),
        name: 'spring_girl',
        size: p.size,
        stateMachines: const {},
        bestScale: 100,
        aware: aware,
        ws: <S>[
          S(
            name: 'the left tree and squirrel',
            //isVisible: false,
          ),
          S(
            name: 'the right tree and nest with birds',
            //isVisible: false,
          ),
          S(
            name: 'bushes',
            isVisible: false,
            position: p.bottomRight,
            anchor: Anchor.bottomRight,
          ),
          S(
            name: 'element_left',
            position: 'left 2567',
          ),
          S(
            name: 'element_top',
            position: '1234 top',
          ),
          S(
            name: 'element_right',
            position: 'right 2567',
          ),
          S(
            name: 'element_bottom',
            position: '1234 bottom',
          ),
        ],
      );

      final oString = o.sjson;
      final oRecovered = await PictureSource.fromString(oString, o.aware, 1);

      expect(o.name, oRecovered.name);

      expect(o.welementSourceList.length, oRecovered.welementSourceList.length);

      for (var i = 0; i < o.welementSourceList.length; ++i) {
        final a = o.welementSourceList[i];
        final b = oRecovered.welementSourceList[i];
        final r = '$a\n$b';
        expect(a.name, b.name, reason: r);
        expect(a.position.toVector2DependsOfSize(p.size),
            b.position.toVector2DependsOfSize(p.size),
            reason: r);
        expect(a.anchor.s, b.anchor.s, reason: r);
        expect(a.sm, b.sm, reason: r);
        expect(a.isVisible, b.isVisible, reason: r);
        expect(a.isMute, b.isMute, reason: r);
        expect(a.scale, b.scale, reason: r);
        expect(a, b);
      }

      expect(o.welementSourceList, oRecovered.welementSourceList);

      expect(oString, oRecovered.sjson);
      expect(o, oRecovered);
    });

    test('demo picture recovered from file', () async {
      const p = PictureHelper(4096, 3072);
      final o = PictureSource(
        aspectSize: aware.preferredScreenAspectSize(),
        name: 'test_4096x3072_without_default_values',
        size: p.size,
        stateMachines: const <String, StateMachineData>{},
        bestScale: 100,
        aware: aware,
        ws: <S>[
          S(
            name: '384x3072',
            isVisible: false,
            position: p.centerRight,
            anchor: Anchor.centerRight,
          ),
          S(
            name: '4096x384 A',
            isVisible: false,
            position: p.topLeft,
            anchor: Anchor.topLeft,
          ),
          S(
            name: '4096x384 B',
            position: p.bottomRight,
            anchor: Anchor.bottomRight,
          ),
          S(
            name: '4096x384 C',
            isVisible: false,
            position: p.bottomRight + Vector2(-4096, -384),
            anchor: Anchor.topLeft,
          ),
          S(
            name: '384x384',
            position: p.center,
            anchor: Anchor.centerRight,
          ),
          S(
            name: '512x512',
            position: p.center,
            scale: 2,
            isMute: true,
          ),
        ],
      );

      const path = 'test/data/test_4096x3072_without_default_values.json';
      final oRecovered = await PictureSource.fromFile(path, o.aware, 1);

      expect('test_4096x3072_without_default_values', oRecovered.name);

      expect(o.welementSourceList.length, oRecovered.welementSourceList.length);

      for (var i = 0; i < o.welementSourceList.length; ++i) {
        final a = o.welementSourceList[i];
        final b = oRecovered.welementSourceList[i];
        final r = '$a\n$b';
        expect(a.name, b.name, reason: r);
        expect(a.position.toVector2DependsOfSize(p.size),
            b.position.toVector2DependsOfSize(p.size),
            reason: r);
        expect(a.anchor.s, b.anchor.s, reason: r);
        expect(a.sm, b.sm, reason: r);
        expect(a.isVisible, b.isVisible, reason: r);
        expect(a.isMute, b.isMute, reason: r);
        expect(a.scale, b.scale, reason: r);
        expect(a, b);
      }

      expect(o, oRecovered);
    });

    test('demo picture recovered from JSON depends a picture size', () async {
      const p = PictureHelper(4096, 3072);
      final o = PictureSource(
        aspectSize: aware.preferredScreenAspectSize(),
        name: 'test_4096x3072_depends_picture_size',
        size: p.size,
        stateMachines: const {},
        bestScale: 100,
        aware: aware,
        ws: <S>[
          S(
            name: '384x3072',
            isVisible: false,
            position: p.centerRight,
            anchor: Anchor.centerRight,
          ),
          S(
            name: '4096x384 A',
            isVisible: false,
            position: p.topLeft,
            anchor: Anchor.topLeft,
          ),
          S(
            name: '4096x384 B',
            position: p.bottomRight,
            anchor: Anchor.bottomRight,
          ),
          S(
            name: '4096x384 C',
            isVisible: false,
            position: p.bottomRight + Vector2(-4096, -384),
            anchor: Anchor.topLeft,
          ),
          S(
            name: '384x384',
            position: p.center,
            anchor: Anchor.centerRight,
          ),
          S(
            name: '512x512',
            //isVisible: false,
            position: p.center,
            scale: 2,
            isMute: true,
          ),
        ],
      );

      const path = 'test/data/test_4096x3072_depends_picture_size.json';
      final oRecovered = await PictureSource.fromFile(path, o.aware, 1);

      expect('test_4096x3072_depends_picture_size', oRecovered.name);

      expect(6, oRecovered.welementSourceList.length);

      for (var i = 0; i < o.welementSourceList.length; ++i) {
        final a = o.welementSourceList[i];
        final b = oRecovered.welementSourceList[i];
        final r = '$a\n$b';
        expect(a.position.toVector2DependsOfSize(p.size),
            b.position.toVector2DependsOfSize(p.size),
            reason: r);
      }

      /* - Positions was converted from string representation to Vector2.
      expect(o.welementSourceList, oRecovered.welementSourceList);
      expect(o, oRecovered);
      */
    });
  });
}
