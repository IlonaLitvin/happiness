import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_flame_helpers/flutter_flame_helpers.dart';

import '../cards/preview_card.dart';
import '../config.dart';
import '../game_components/game_components.dart';
import 'render_animation_welement.dart';
import 'welement.dart';

/// \see Notes for [AnimationComponent].
class AnimationWelement extends Welement with RenderAnimationWelement {
  AnimationWelement({
    required super.canvasName,
    required super.canvasSize,
    required super.bestScale,
    required super.welementSource,
    required super.screenSize,
    super.fsm,
    super.onAfterInitHandler,
  });

  @override
  void onMount() async {
    super.onMount();

    position
        .setFrom(welementSource.position.toVector2DependsOfSize(canvasSize));
    anchor = welementSource.anchor;

    late final bool ok;
    try {
      ok = await init();
    } catch (ex, stacktrace) {
      ok = false;
      Fimber.w(ex.toString(), ex: ex, stacktrace: stacktrace);
    } finally {
      super.onAfterInit(ok);
    }
  }

  Future<bool> init() async {
    final previewCard = await PreviewCard.fromId(canvasName);
    if (previewCard == null) {
      Fimber.w('Not found a card by id `$canvasName`.');
      return false;
    }

    animationComponent = AnimationComponent(
      previewCard: previewCard,
      name: name,
      bestScale: bestScale,
      scale: ownScaleWithBestScale,
      startAnimation: 'idle_offset',
      loop: true,
      fit: BoxFit.scaleDown,
    );
    await animationComponent!.init();

    size.setFrom(animationComponent!.size);

    if (C.debugAnimation) {
      Fimber.i('animation for `$canvasName`'
          '\n\tstate $stateName'
          '\n\tposition $position'
          '\n\tsize $size'
          '\n\townScaleWithBestScale ${ownScaleWithBestScale.s2}');
    }

    return true;
  }

  @mustCallSuper
  @override
  void onStateUpdated() {
    super.onStateUpdated();

    //init();
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll(<String, dynamic>{});
}
