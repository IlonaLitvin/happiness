import 'package:dart_helpers/dart_helpers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/card_aware.dart';
import 'package:happiness/effects/color_to_grey.dart';
import 'package:happiness/effects/grey_to_color.dart';
import 'package:happiness/effects/play_sound_by_tap.dart';
import 'package:happiness/effects/scale_in_out.dart';
import 'package:happiness/picture_source.dart';
import 'package:happiness/state_machine_data.dart';
import 'package:mockito/mockito.dart';

import 'init_test_environment.dart';

class MockBuildContext extends Mock implements BuildContext {
  @override
  Widget get widget => Container();
}

void main() {
  initTestEnvironment();

  group('JsonSerializable', () {
    test('state machine data with states only (from code)', () {
      const o = StateMachineData(
        transitions: [
          /* In JSON:
          "spring -> onTap -> summer"
          */
          WTransition('spring', WActions.onTap, 'summer'),
          WTransition('summer', WActions.onEnd, 'autumn'),
          WTransition('autumn', WActions.onEnd, 'winter'),
          WTransition('winter', WActions.onEnd, 'spring'),
        ],
      );
      final oString = o.sjson;
      final oRecovered = StateMachineData.fromString(oString);

      expect(o.transitionList.length, oRecovered.transitionList.length,
          reason: '$o');
      expect(o.transitionList, oRecovered.transitionList);
      expect(o.directorList.length, oRecovered.directorList.length,
          reason: '$o');
      expect(oString, oRecovered.sjson);
    });

    test('inline state machine data with directors (from code)', () {
      const o = StateMachineData(
        transitions: [
          WTransition('idle', WActions.onTap, 'tap_reaction'),
          WTransition('tap_reaction', WActions.onEnd, 'idle'),
        ],
        /* In JSON:
        {
          "idle":
          [
            {
              "ColorToGrey":
              {
                "duration": 0
              }
          ],
          "tap_reaction":
          [
            {
              "ScaleInOut":
              {
                "duration": 0.5,
                "scale": 1.2
              }
            },
            {
              "PlaySoundByTap":
              {
              }
            }
          ]
        }
        */
        directors: [
          WDirector('idle', [ColorToGrey(duration: 0.0)]),
          WDirector(
            'tap_reaction',
            [ScaleInOut(duration: 0.5, scale: 1.2), PlaySoundByTap()],
          ),
        ],
      );
      final oJson = o.toJson();
      final oRecovered = StateMachineData.fromJson(oJson);

      expect(o.directorList.length, oRecovered.directorList.length,
          reason: '$o');
      expect(o.directorList, oRecovered.directorList);
      expect(oJson, oRecovered.toJson());
    });

    test('inline state machine data with directors (from JSON)', () async {
      const path = 'test/data/test_inline_fsm.json';
      final oRecovered =
          await PictureSource.fromFile(path, CardAware(MockBuildContext()), 1);

      expect(oRecovered.name, 'test_inline_fsm');

      const transitions = [
        WTransition('grey', WActions.onTap, 'idle'),
        WTransition('idle', WActions.onTap, 'tap_reaction'),
        WTransition('tap_reaction', WActions.onEnd, 'idle'),
      ];

      const directors = [
        WDirector('grey', [ColorToGrey(duration: 0.0)]),
        WDirector('idle', [
          ScaleInOut(duration: 1.5, scale: 1.2, curve: Curves.bounceOut),
          GreyToColor(duration: 1.2),
        ]),
        WDirector('tap_reaction', [
          ScaleInOut(duration: 2.5, scale: 2.2, curve: Curves.bounceIn),
          PlaySoundByTap(),
        ]),
      ];

      const sm = StateMachineData(
        transitions: transitions,
        directors: directors,
      );

      expect(oRecovered.welementSourceList.length, 1);
      final welementSource = oRecovered.welementSourceList.first;

      expect(welementSource.sm.transitionList, sm.transitionList);
      expect(welementSource.sm.directorList, sm.directorList);
      expect(welementSource.sm, sm);
    });

    test('outline state machine data with directors (from JSON)', () async {
      const path = 'test/data/test_outline_fsm.json';
      final oRecovered =
          await PictureSource.fromFile(path, CardAware(MockBuildContext()), 1);

      expect(oRecovered.name, 'test_outline_fsm');

      const transitions = [
        WTransition('grey', WActions.onTap, 'idle'),
        WTransition('idle', WActions.onTap, 'tap_reaction'),
        WTransition('tap_reaction', WActions.onEnd, 'idle'),
      ];

      const directors = [
        WDirector('grey', [ColorToGrey(duration: 0.0)]),
        WDirector('idle', [
          ScaleInOut(duration: 1.5, scale: 1.2, curve: Curves.bounceOut),
          GreyToColor(duration: 1.2),
        ]),
        WDirector('tap_reaction', [
          ScaleInOut(duration: 2.5, scale: 2.2, curve: Curves.bounceIn),
          PlaySoundByTap(),
        ]),
      ];

      const sm = StateMachineData(
        transitions: transitions,
        directors: directors,
      );

      expect(oRecovered.stateMachines.length, 1);
      expect(oRecovered.stateMachines.keys.first, 'GreyIdleTapReaction');
      expect(oRecovered.stateMachines.values.first, sm);

      expect(oRecovered.welementSourceList.length, 1);
      final welementSource = oRecovered.welementSourceList.first;

      expect(welementSource.sm.transitionList, sm.transitionList);
      expect(welementSource.sm.directorList, sm.directorList);
      expect(welementSource.sm, sm);
    });
  });
}
