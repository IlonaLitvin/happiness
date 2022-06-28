import 'package:api_happiness/api_happiness.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../config.dart';
import 'scope/scope.dart';
import 'scope/scope_factory.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'how_to_get.g.dart';

@JsonSerializable(
    ignoreUnannotated: true, includeIfNull: false, createFactory: false)
class HowToGet extends Equatable {
  @JsonKey()
  final CardType cardType;

  @JsonKey()
  final String cardId;

  @JsonKey()
  final List<Scope> scopes;

  const HowToGet({
    required this.cardType,
    required this.cardId,
    required this.scopes,
  }) : assert(cardId.length > 0);

  const HowToGet.allVariantsFree({
    required CardType cardType,
    required String cardId,
  }) : this(cardType: cardType, cardId: cardId, scopes: const []);

  const HowToGet.undefined()
      : this.allVariantsFree(cardType: CardType.undefined, cardId: '?');

  /// \warning Whole picture JSON.
  factory HowToGet.fromJson(Map<String, dynamic> jsonCard) =>
      HowToGet.fromJsonCard(jsonCard);

  /// \param json Full card JSON.
  /// \see cards.json
  factory HowToGet.fromJsonCard(Map<String, dynamic> jsonCard) {
    final keyType = (jsonCard['type'] ?? '') as String;
    final type =
        EnumToString.fromString(CardType.values, keyType) ?? CardType.undefined;
    final id = (jsonCard['id'] ?? '') as String;

    // we are understand an object and a map
    // \todo Don't do that! Work out where an object comes from instead of a map.
    final dynamic rawHowToGet = jsonCard['how_to_get'];
    if (rawHowToGet is HowToGet) {
      return rawHowToGet;
    }

    final jsonHowToGet =
        (rawHowToGet ?? <String, dynamic>{}) as Map<String, dynamic>;

    return HowToGet._fromJsonWithCard(type, id, jsonHowToGet);
  }

  factory HowToGet._fromJsonWithCard(
    CardType cardType,
    String cardId,
    Map<String, dynamic> json,
  ) {
    final jsonScopes = (json['scopes'] ?? <dynamic>[]) as List<dynamic>;
    final scopes = <Scope>[];
    for (final o in jsonScopes) {
      if (o is! Map<String, dynamic>) {
        throw 'Should be map. Received: `$o`.';
      }

      if (needIgnoreJsonKey(o, 'scope')) {
        Fimber.w('Excluded `$o` because ID has ignore prefix.');
        continue;
      }

      o['card_type'] = EnumToString.convertToString(cardType);
      o['card_id'] = cardId;
      final scope = ScopeFactory.fromJsonCard(o);
      scopes.add(scope);
      if (C.debugBloc) {
        Fimber.i('Added `$scope`.');
      }
    }

    return HowToGet(cardType: cardType, cardId: cardId, scopes: scopes);
  }

  bool get isFree =>
      scopes.isEmpty || (scopes.length == 1 && scopes.first.isFree);

  @override
  List<Object?> get props => [cardType.name, cardId, scopes];

  Map<String, dynamic> toJson() => _$HowToGetToJson(this);
}
