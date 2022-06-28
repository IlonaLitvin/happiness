/* TODO
import 'package:fimber/fimber.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import '../effects/run_once.dart';
import '../effects/weffect.dart';
import '../welement.dart';

class FlipHorizontal extends WEffect {
  /// in seconds
  final double duration;

  /// \see Click Ctrl+`Curve` or look at https://youtu.be/qnnlGcZ8vaQ for build an own curve.
  final Curve curve;

  const FlipHorizontal(
    this.duration, {
    this.curve = Curves.ease,
  })  : assert(duration > 0),
        super('FlipHorizontal');

  @override
  @mustCallSuper
  void run(Welement we) {
    super.run(we);
    Fimber.i('duration $duration');

    //_run1(we);
    _run2(we);
  }

  void _run1(Welement we) {
    final originalSize = we.size;

    const scaleToLine = 0.01;
    final delta = originalSize.x * (1 - scaleToLine).abs();
    final speed = delta / duration;
    Fimber.i('speed $speed');

    final toLineEffect = ScaleEffect(
      size: Vector2(originalSize.x * scaleToLine, originalSize.y),
      speed: speed,
      curve: curve,
      isInfinite: false,
      isAlternating: true,
      //onComplete: () => we.renderFlipX = !we.renderFlipX,
      onComplete: () => Fimber.i('scale to line completed'),
    );

    final flipXEffect = RunOnce(
      code: (Welement w) {
        Fimber.i('renderFlipX = ${!w.renderFlipX}');
        w.renderFlipX = !w.renderFlipX;
      },
      onComplete: () => Fimber.i('scale from line completed'),
    );

    final fromLineEffect = ScaleEffect(
      size: originalSize,
      speed: speed,
      curve: curve,
      isInfinite: false,
      isAlternating: true,
      onComplete: () => Fimber.i('scale from line completed'),
    );

    final sequence = SequenceEffect(
      effects: [toLineEffect, flipXEffect, fromLineEffect],
      isInfinite: false,
      isAlternating: true,
      onComplete: () => onComplete(we),
    );

    we.addEffect(sequence);
  }

  void _run2(Welement we) {
    final originalSize = we.size;

    const scaleToLine = 0.01;
    final delta = originalSize.x * (1 - scaleToLine).abs();
    final speed = delta / duration;
    Fimber.i('speed $speed');

    final fromLineEffect = ScaleEffect(
      size: originalSize,
      speed: speed,
      curve: curve,
      isInfinite: false,
      isAlternating: true,
      onComplete: () => onComplete(we),
    );

    final toLineEffect = ScaleEffect(
      size: Vector2(originalSize.x * scaleToLine, originalSize.y),
      speed: speed,
      curve: curve,
      isInfinite: false,
      isAlternating: true,
      onComplete: () {
        we.renderFlipX = !we.renderFlipX;
        we.addEffect(fromLineEffect);
      },
    );

    we.addEffect(toLineEffect);
  }
}
*/
