import 'package:dart_helpers/dart_helpers.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import 'about_card.dart';
import 'card_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'later_about_card.g.dart';

@JsonSerializable(includeIfNull: false)
class LaterAboutCard extends AboutCard {
  final Map<String, dynamic> sequence;

  const LaterAboutCard({
    required super.id,
    required super.originalSize,
    required super.compositions,
    required super.elements,
    required super.previews,
    required this.sequence,
  })  : assert(sequence.length > 0),
        super(type: CardType.later);

  factory LaterAboutCard.fromJson(Map<String, dynamic> json) =>
      _$LaterAboutCardFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LaterAboutCardToJson(this);
}
