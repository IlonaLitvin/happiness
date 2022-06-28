import 'package:enum_to_string/enum_to_string.dart';
import 'package:fimber/fimber.dart';

import 'brick.dart';
import 'link_brick.dart';
import 'links_brick.dart';
import 'rate_brick.dart';
import 'text_brick.dart';

// ignore: avoid_classes_with_only_static_members
class BrickFactory {
  static Brick fromJson(Map<String, dynamic> json) {
    final dynamic keyType = json['type'];
    if (keyType == null) {
      throw "Can't found a type for\n$json.";
    }

    final type = EnumToString.fromString(BrickType.values, keyType as String) ??
        BrickType.undefined;

    final builder = _detectBuilder(type);
    Fimber.i('Found builder: $builder');
    if (builder == null) {
      throw 'Undefined builder for type `$keyType`.';
    }

    try {
      return builder(json);
    } catch (ex) {
      Fimber.e("Can't build a brick by data\n$json.", ex: ex);
      rethrow;
    }
  }

  static BrickBuilderJson? _detectBuilder(BrickType type) =>
      const <BrickType, BrickBuilderJson>{
        // \todo BrickType.button: ButtonBrick.fromJson,
        BrickType.link: LinkBrick.fromJson,
        BrickType.links: LinksBrick.fromJson,
        BrickType.rate: RateBrick.fromJson,
        BrickType.text: TextBrick.fromJson,
      }[type];
}
