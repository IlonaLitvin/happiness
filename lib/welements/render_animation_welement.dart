import 'package:flutter/painting.dart';

import '../game_components/game_components.dart';
import 'welement.dart';

mixin RenderAnimationWelement on Welement {
  AnimationComponent? animationComponent;

  /// Use this to override the colour used (to apply tint or opacity).
  /// \see RenderSpriteWelement
  Paint? overridePaint;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (animationComponent == null) {
      return;
    }

    final ac = animationComponent!;
    ac.spineRender.skeletonRender?.defaultPaint = overridePaint;
    ac.render(canvas);
  }
}
