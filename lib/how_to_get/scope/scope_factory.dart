import 'package:api_happiness/api_happiness.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:fimber/fimber.dart';

import 'all_variants_scope.dart';
import 'scope.dart';
import 'scope_type.dart';

typedef ScopeBuilderJson = Scope Function(
  CardType,
  String cardId,
  Map<String, dynamic> json,
);

// ignore: avoid_classes_with_only_static_members
class ScopeFactory {
  static Scope fromJsonCard(Map<String, dynamic> json) {
    final keyType = (json['card_type'] ?? '') as String;
    final cardType =
        EnumToString.fromString(CardType.values, keyType) ?? CardType.undefined;
    final cardId = json['card_id'] as String;

    return ScopeFactory._fromJsonWithCard(cardType, cardId, json);
  }

  static Scope _fromJsonWithCard(
    CardType cardType,
    String cardId,
    Map<String, dynamic> json,
  ) {
    assert(cardType != CardType.undefined);
    assert(cardId.isNotEmpty);

    final keyScope = (json['scope'] ?? '') as String;
    final scope = EnumToString.fromString(ScopeType.values, keyScope) ??
        ScopeType.undefined;
    final builder = _detectBuilder(scope);
    Fimber.i('Found builder: $builder');
    if (builder == null) {
      throw 'Undefined builder for scope `${scope.name}`.';
    }

    return builder(cardType, cardId, json);
  }

  static ScopeBuilderJson? _detectBuilder(ScopeType scope) =>
      const <ScopeType, ScopeBuilderJson>{
        ScopeType.all_variants: AllVariantsScope.fromJsonWithCard,
      }[scope];
}
