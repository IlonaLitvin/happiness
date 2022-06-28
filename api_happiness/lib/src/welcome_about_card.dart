import 'package:dart_helpers/dart_helpers.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import 'about_card.dart';
import 'card_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'welcome_about_card.g.dart';

@JsonSerializable(includeIfNull: false)
class WelcomeAboutCard extends AboutCard {
  final String title1;
  final String title2;
  final String subtitle;
  final Map<String, dynamic>? privacy;
  final Map<String, dynamic>? terms;

  const WelcomeAboutCard({
    required super.id,
    required super.originalSize,
    required super.compositions,
    required super.elements,
    required super.previews,
    required this.title1,
    required this.title2,
    required this.subtitle,
    this.privacy,
    this.terms,
  })  : assert(title1.length > 0 || title2.length > 0 || subtitle.length > 0,
            'At least some text should be specified.'),
        super(type: CardType.welcome);

  factory WelcomeAboutCard.fromJson(Map<String, dynamic> json) =>
      _$WelcomeAboutCardFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WelcomeAboutCardToJson(this);
}
