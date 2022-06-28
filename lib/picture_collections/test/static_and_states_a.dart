import 'package:flame/components.dart';

import '../../card_aware.dart';
import '../../picture_helper.dart';
import '../../picture_source.dart';
import '../../state_machine_data.dart';
import '../../welements/welement_source.dart';
import '../picture_collection.dart';

/// Example with static sprite elements and states.
class PictureCollectionStaticAndStatesA extends PictureCollection {
  static const p = PictureHelper(4100, 3075);

  static Future fromCode(CardAware aware) async => PictureCollection()
    ..data = <PictureSource>[
      PictureSource(
        aspectSize: aware.preferredScreenAspectSize(),
        name: 'test_static_states',
        size: p.size,
        stateMachines: const {},
        bestScale: 100,
        aware: aware,
        ws: <S>[
          S(
            name: 'tree_left',
            //isVisible: false,
            position: p.topLeft,
            anchor: Anchor.topLeft,
            //sm: smTreeLeftOnTap,
            sm: smTreeLeftOnTapAndOnEnd,
          ),
          S(
            name: 'bushes_right',
            //isVisible: false,
            position: p.bottomRight,
            anchor: Anchor.bottomRight,
          ),
        ],
      ),
    ];

  static const smTreeLeftOnTap = StateMachineData(
    transitions: [
      WTransition('spring', WActions.onTap, 'summer'),
      WTransition('summer', WActions.onTap, 'autumn'),
      WTransition('autumn', WActions.onTap, 'winter'),
      WTransition('winter', WActions.onTap, 'spring'),
    ],
  );

  static const smTreeLeftOnTapAndOnEnd = StateMachineData(
    transitions: [
      WTransition('spring', WActions.onTap, 'summer'),
      WTransition('summer', WActions.onEnd, 'autumn'),
      WTransition('autumn', WActions.onEnd, 'winter'),
      WTransition('winter', WActions.onEnd, 'spring'),
    ],
  );
}
