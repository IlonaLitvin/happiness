import '../../card_aware.dart';
import '../../picture_helper.dart';
import '../../picture_source.dart';
import '../../state_machine_data.dart';
import '../../welements/welement_source.dart';
import '../picture_collection.dart';

/// Example with animated elements and states.
class PictureCollectionAnimatedA extends PictureCollection {
  static const p = PictureHelper(4096, 4096);

  static Future fromCode(CardAware aware) async => PictureCollection()
    ..data = <PictureSource>[
      PictureSource(
        aspectSize: aware.preferredScreenAspectSize(),
        name: 'test_animation_code_w_a',
        size: p.size,
        stateMachines: const {},
        bestScale: 100,
        aware: aware,
        ws: <S>[
          S(
            name: 'chopper',
            //isVisible: false,
            position: p.center / 2,
            scale: 12,
          ),
          S(
            name: 'brock',
            //isVisible: false,
            position: p.center,
            scale: 1,
          ),
        ],
      ),
      PictureSource(
        aspectSize: aware.preferredScreenAspectSize(),
        name: 'test_animation_code',
        size: p.size,
        stateMachines: const <String, StateMachineData>{},
        bestScale: 100,
        aware: aware,
        ws: <S>[
          S(
            name: 'butterfly_orange',
            //isVisible: false,
            position: p.center,
            sm: smButterflyOrange,
            scale: 5,
          ),
          S(
            name: 'chopper',
            //isVisible: false,
            position: p.center / 2,
            scale: 12,
          ),
        ],
      ),
    ];

  static const smButterflyOrange = StateMachineData(
    transitions: [
      WTransition('idle', WActions.onTap, 'tap_reaction'),
      WTransition('tap_reaction', WActions.onEnd, 'idle'),
    ],
  );
}
