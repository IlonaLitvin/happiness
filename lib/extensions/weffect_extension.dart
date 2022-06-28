import 'package:collection/collection.dart' show IterableExtension;

import '../effects/color_to_grey.dart';
import '../effects/grey_to_color.dart';
import '../effects/play_sound_by_tap.dart';
import '../effects/scale_in_out.dart';
import '../effects/sprite_to_animation.dart';
import '../effects/weffect.dart';

extension WEffectExtension on WEffect {
  static const prototypeList = <String, Function(Map<String, dynamic>)>{
    'ColorToGrey': ColorToGrey.fromJson,
    'GreyToColor': GreyToColor.fromJson,
    'PlaySoundByTap': PlaySoundByTap.fromJson,
    'ScaleInOut': ScaleInOut.fromJson,
    'SpriteToAnimation': SpriteToAnimation.fromJson,
  };

  String get s =>
      prototypeList.keys.firstWhereOrNull(
        (key) => prototypeList[key]! as WEffect == this,
      ) ??
      '';
}

extension WEffectBuildMapExtension on Map<String, dynamic> {
  WEffect get buildEffect {
    assert(isEffect);
    final name = keys.first;
    final prototypeEffect = WEffectExtension.prototypeList[name]!;
    final params = values.first as Map<String, dynamic>;
    return prototypeEffect(params) as WEffect;
  }

  bool get isEffect {
    final name = keys.first;
    return WEffectExtension.prototypeList.keys.contains(name);
  }
}
