import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../config.dart';
import '../welements/animation_welement.dart';
import '../welements/sprite_welement.dart';

typedef ColorFilterMatrix = List<double>;

/// \thanks https://kazzkiq.github.io/svg-color-filter/
/// \see http://alistapart.com/article/finessing-fecolormatrix/
/// \todo Add more effects.
class VisualComponentRenderEffect extends ComponentEffect<PositionComponent> {
  static const greyColorFilterMatrix = <double>[
    // greyscale
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0
  ];

  static const identityColorFilterMatrix = <double>[
    // identity
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const inverseColorFilterMatrix = <double>[
    // inverse
    -1, 0, 0, 0, 255,
    0, -1, 0, 0, 255,
    0, 0, -1, 0, 255,
    0, 0, 0, 1, 0,
  ];

  static const sepiaColorFilterMatrix = <double>[
    // sepia
    0.393, 0.769, 0.189, 0, 0,
    0.349, 0.686, 0.168, 0, 0,
    0.272, 0.534, 0.131, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const defaultCurve = Curves.linear;
  final Curve curve;

  static const defaultDuration = 1.0;
  final double duration;

  bool get isWithoutDuration => duration == 0.0;

  /// Used to be able to determine the start state of the component.
  ColorFilterMatrix startColorFilterMatrix;
  double startOpacity;

  /// Used to be able to determine the end state of a sequence of effects.
  ColorFilterMatrix endColorFilterMatrix;
  double endOpacity;

  /// Whether the state of a field was slowly modified by the effect.
  bool get isModifies => isModifiesColorFilterMatrix || isModifiesOpacityMatrix;

  bool get isModifiesColorFilterMatrix =>
      startColorFilterMatrix != endColorFilterMatrix;

  bool get isModifiesOpacityMatrix => startOpacity != endOpacity;

  /// Whether the state of a field was immediately modified by the effect.
  bool get isImmediately =>
      isImmediatelyColorFilterMatrix && isImmediatelyOpacity;

  bool get isImmediatelyColorFilterMatrix =>
      isWithoutDuration || startColorFilterMatrix == endColorFilterMatrix;

  bool get isImmediatelyOpacity =>
      isWithoutDuration || startOpacity == endOpacity;

  VisualComponentRenderEffect({
    this.duration = defaultDuration,
    this.curve = defaultCurve,
    this.startColorFilterMatrix = identityColorFilterMatrix,
    this.startOpacity = 1.0,
    this.endColorFilterMatrix = identityColorFilterMatrix,
    this.endOpacity = 1.0,
    super.onComplete,
  })  : assert(duration >= 0, 'Duration should be greater or equals 0.'),
        assert(startColorFilterMatrix.length == 5 * 4,
            'Should contains 5 x 4 = 20 elements.'),
        assert(endColorFilterMatrix.length == 5 * 4,
            'Should be 5 x 4 = 20 elements.'),
        super(EffectController(
          duration: duration,
          curve: curve,
        ));

  @mustCallSuper
  @override
  void update(double dt) {
    super.update(dt);

    if (!isModifies) {
      return;
    }

    final op = _overridePaint(controller.progress);
    if (parent is AnimationWelement) {
      final we = parent! as AnimationWelement;
      we.overridePaint = op;
    } else if (parent is SpriteWelement) {
      final we = parent! as SpriteWelement;
      we.overridePaint = op;
    } else {
      Fimber.w('Unrecognized parent. $parent');
    }
  }

  @override
  void onFinish() {
    if (onComplete != null) {
      onComplete!();
    }

    final op = _overridePaint(1.0);
    if (parent is AnimationWelement) {
      final we = parent! as AnimationWelement;
      we.overridePaint = op;
    } else if (parent is SpriteWelement) {
      final we = parent! as SpriteWelement;
      we.overridePaint = op;
    } else {
      Fimber.w('Unrecognized parent. $parent');
    }

    super.onFinish();
  }

  Paint _overridePaint(double t) {
    if (C.debugEffect) {
      Fimber.i('t ${t.s3}');
    }

    final paint = Paint();

    if (isImmediatelyColorFilterMatrix) {
      paint.colorFilter = ColorFilter.matrix(endColorFilterMatrix);
      return paint;
    }

    final m = <double>[];
    for (var i = 0; i < startColorFilterMatrix.length; ++i) {
      m.add(startColorFilterMatrix[i] +
          (endColorFilterMatrix[i] - startColorFilterMatrix[i]) * t);
    }
    paint.colorFilter = ColorFilter.matrix(m);

    //paint.color = Color.fromRGBO(0, 0, 0, 0.7);
    //paint.blendMode = BlendMode.srcATop;
    //paint.colorFilter = ColorFilter.mode(Colors.grey, BlendMode.srcATop);

    return paint;
  }

  @override
  void apply(double progress) {
    // the `controller` manage the `progress`
  }
}
