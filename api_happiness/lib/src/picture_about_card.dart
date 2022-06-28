import 'package:dart_helpers/dart_helpers.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import 'about_card.dart';
import 'card_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'picture_about_card.g.dart';

@JsonSerializable(includeIfNull: false)
class PictureAboutCard extends AboutCard {
  final String name;
  final List<String> masterminds;
  final List<String> artists;
  final List<String> animators;
  final List<String> thanks;

  const PictureAboutCard({
    required super.id,
    required super.originalSize,
    required super.compositions,
    required super.elements,
    required super.previews,
    required this.name,
    required this.masterminds,
    required this.artists,
    required this.animators,
    required this.thanks,
  })  : assert(name.length > 0),
        super(type: CardType.picture);

  factory PictureAboutCard.fromJson(Map<String, dynamic> json) =>
      _$PictureAboutCardFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PictureAboutCardToJson(this);
}
