import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../config.dart';
import '../effects/weffect.dart';
import '../state_machine_data.dart';
import '../welements/animation_welement.dart';
import '../welements/welement.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'sprite_to_animation.g.dart';

@JsonSerializable(includeIfNull: false)
class SpriteToAnimation extends WEffect {
  final String animation;

  const SpriteToAnimation({
    required this.animation,
  })  : assert(animation.length > 0),
        super(
          name: 'SpriteToAnimation',
          duration: 0,
        );

  @override
  @mustCallSuper
  void run(Welement we) async {
    super.run(we);

    // add animation and remove sprite when success
    final animation = AnimationWelement(
      canvasName: we.canvasName,
      welementSource: we.welementSource,
      screenSize: we.screenSize,
      canvasSize: we.canvasSize,
      bestScale: we.bestScale,
      fsm: we.fsm,
      onAfterInitHandler: (bool ok) => _onAfterInitHandler(we, ok),
    );
    await we.gameRef.add(animation);
  }

  void _onAfterInitHandler(Welement we, bool ok) {
    if (C.debugAnimation) {
      Fimber.i('Init animation for `${we.name}` is `$ok`.'
          ' Request to remove sprite `${we.name}`...');
    }

    if (ok) {
      we.removeFromParent();
      we.sendActionFsm(const OnEndAction());
    }
  }

  factory SpriteToAnimation.fromJson(Map<String, dynamic> json) =>
      _$SpriteToAnimationFromJson(json);

  @mustCallSuper
  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$SpriteToAnimationToJson(this));
}
