import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_helpers/flutter_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../effects/weffect.dart';
import '../state_machine_data.dart';
import '../welements/welement.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'scale_in_out.g.dart';

@JsonSerializable(includeIfNull: false)
class ScaleInOut extends WEffect {
  final double scale;

  const ScaleInOut({
    double duration = 1.0,
    this.scale = 1.2,
    Curve curve = CurveJsonConverter.defaultCurve,
  })  : assert(duration > 0),
        assert(scale > 0),
        super(
          name: 'ScaleInOut',
          duration: duration,
          curve: curve,
        );

  @override
  @mustCallSuper
  void run(Welement we) {
    super.run(we);

    // \todo SPIKE Run effect on `onComplete()` with fading parameters. Meta effect.
    final effect = _ScaleEffect(
      we: we,
      scale: Vector2.all(scale),
      controller: EffectController(
        duration: duration,
        curve: curve,
        alternate: true,
      ),
    );
    we.add(effect);
  }

  factory ScaleInOut.fromJson(Map<String, dynamic> json) =>
      _$ScaleInOutFromJson(json);

  @mustCallSuper
  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$ScaleInOutToJson(this));
}

class _ScaleEffect extends ScaleEffect {
  final Welement we;

  _ScaleEffect({
    required this.we,
    required Vector2 scale,
    required EffectController controller,
  }) : super.by(scale, controller);

  @override
  void onFinish() {
    we.sendActionFsm(const OnEndAction());

    super.onFinish();
  }
}
