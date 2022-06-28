import 'package:dart_helpers/dart_helpers.dart';
import 'package:equatable/equatable.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart';

import 'card_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'about_card.g.dart';

/// About card without content.
/// \see Card
/// \see Folder `about` into the cards.
@JsonSerializable(includeIfNull: false)
class AboutCard extends Equatable {
  final CardType type;
  final String id;

  @JsonKey(name: 'original_size')
  @Vector2IntJsonConverter()
  final Vector2 originalSize;

  final List<String> compositions;

  /// \see [availableScales]
  final List<int> elements;

  /// In percents.
  List<int> get availableScales => elements;

  /// Images or animations for preview the card.
  ///   "previews": [
  ///     "4to3/256x192/canvas"
  ///   ]
  final List<String> previews;

  const AboutCard({
    required this.type,
    required this.id,
    required this.originalSize,
    required this.compositions,
    required this.elements,
    required this.previews,
  }) : assert(id.length > 0);

  AboutCard.undefined()
      : this(
          type: CardType.undefined,
          id: '?',
          originalSize: Vector2.zero(),
          compositions: const [],
          elements: const [],
          previews: const [],
        );

  bool get isUndefined => type == CardType.undefined;

  factory AboutCard.fromJson(Map<String, dynamic> json) =>
      _$AboutCardFromJson(json);

  Map<String, dynamic> toJson() => _$AboutCardToJson(this);

  @override
  List<Object?> get props => toJson().keys.toList();
}
