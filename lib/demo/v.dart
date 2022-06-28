import 'package:dart_helpers/dart_helpers.dart';
import 'package:flame/components.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
part 'v.g.dart';

/// A simple class with included class for JSON decode / encode.
/// \thanks https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
@JsonSerializable(includeIfNull: false)
class V {
  final String name;

  @_Vector2Converter()
  final Vector2 position;

  V({required this.name, required this.position});

  factory V.fromString(String s) => V.fromJson(s.jsonMap);

  factory V.fromJson(Map<String, dynamic> json) => _$VFromJson(json);

  Map<String, dynamic> toJson() => _$VToJson(this);

  @override
  String toString() => toJson().sjson;
}

class _Vector2Converter implements JsonConverter<Vector2, List> {
  const _Vector2Converter();

  @override
  Vector2 fromJson(List l) {
    assert(l.length == 2);
    return Vector2(l[0] as double, l[1] as double);
  }

  @override
  List<double> toJson(Vector2 o) {
    return [o.x, o.y];
  }
}
