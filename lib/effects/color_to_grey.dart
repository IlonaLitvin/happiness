import 'package:fimber/fimber.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_helpers/flutter_helpers.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../effects/weffect.dart';
import '../state_machine_data.dart';
import '../welements/animation_welement.dart';
import '../welements/sprite_welement.dart';
import '../welements/welement.dart';
import 'visual_component_render_effect.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'color_to_grey.g.dart';

@JsonSerializable(includeIfNull: false)
class ColorToGrey extends WEffect {
  const ColorToGrey({
    double duration = 1.0,
    Curve curve = CurveJsonConverter.defaultCurve,
  }) : super(
          name: 'ColorToGrey',
          duration: duration,
          curve: curve,
        );

  @override
  @mustCallSuper
  void run(Welement we) {
    super.run(we);

    if (we is! AnimationWelement && we is! SpriteWelement) {
      Fimber.w('This effect can be add to'
          ' AnimationWelement or SpriteWelement.'
          ' Attempt add to `${we.name}`.');
      return;
    }

    final effect = VisualComponentRenderEffect(
      duration: duration,
      startColorFilterMatrix:
          VisualComponentRenderEffect.identityColorFilterMatrix,
      endColorFilterMatrix: VisualComponentRenderEffect.greyColorFilterMatrix,
      onComplete: () => we.sendActionFsm(const OnEndAction()),
    );

    we.add(effect);
  }

  factory ColorToGrey.fromJson(Map<String, dynamic> json) =>
      _$ColorToGreyFromJson(json);

  @mustCallSuper
  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$ColorToGreyToJson(this));
}
