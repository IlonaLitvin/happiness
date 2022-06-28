import 'package:dart_helpers/dart_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
part 'a.g.dart';

/// A simplest class for JSON decode / encode.
/// \thanks https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
@JsonSerializable(includeIfNull: false)
class A {
  final String name;

  A({required this.name});

  factory A.fromString(String s) => A.fromJson(s.jsonMap);

  factory A.fromJson(Map<String, dynamic> json) => _$AFromJson(json);

  Map<String, dynamic> toJson() => _$AToJson(this);

  @override
  String toString() => toJson().sjson;
}

/// A simple glossary. It will read from JSON file.
@JsonLiteral('a_glossary.json')
Map<String, dynamic> get glossary => _$glossaryJsonLiteral;
