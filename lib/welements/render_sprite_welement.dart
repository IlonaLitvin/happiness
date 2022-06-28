import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import 'welement.dart';

mixin RenderSpriteWelement on Welement {
  Sprite? sprite;

  /// Use this to override the colour used (to apply tint or opacity).
  /// If not provided the default is `Sprite.paint`.
  /// \see RenderAnimationWelement
  Paint? overridePaint;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    sprite?.render(
      canvas,
      size: size,
      overridePaint: overridePaint,
    );
  }
}
