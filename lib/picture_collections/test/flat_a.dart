import 'package:flame/components.dart';

import '../../card_aware.dart';
import '../../picture_helper.dart';
import '../../picture_source.dart';
import '../../welements/welement_source.dart';
import '../picture_collection.dart';

/// Example with flat elements.
class PictureCollectionFlatA extends PictureCollection {
  static const p = PictureHelper(4096, 3072);

  static Future fromCode(CardAware aware) async => PictureCollection()
    ..data = <PictureSource>[
      PictureSource(
        aspectSize: aware.preferredScreenAspectSize(),
        name: 'test_4096x3072',
        size: p.size,
        stateMachines: const {},
        bestScale: 100,
        aware: aware,
        ws: <S>[
          S(
            name: '384x3072',
            //isVisible: false,
            position: p.centerRight,
            anchor: Anchor.centerRight,
          ),
          S(
            name: '4096x384',
            //isVisible: false,
            position: p.topLeft,
            anchor: Anchor.topLeft,
          ),
          S(
            name: '4096x384',
            //isVisible: false,
            position: p.bottomRight,
            anchor: Anchor.bottomRight,
          ),
          S(
            name: '4096x384',
            //isVisible: false,
            position: p.bottomRight + Vector2(-4096, -384),
            anchor: Anchor.topLeft,
          ),
          S(
            name: '384x384',
            //isVisible: false,
            position: p.center,
            anchor: Anchor.centerRight,
          ),
          S(
            name: '512x512',
            //isVisible: false,
            position: p.center,
            scale: 2,
          ),
        ],
      ),
    ];
}
