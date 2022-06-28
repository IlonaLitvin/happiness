import 'package:api_happiness/api_happiness.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:fimber/fimber.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../../config.dart';
import 'cost/cost.dart';
import 'cost/cost_factory.dart';
import 'cost/cost_type.dart';
import 'scope.dart';
import 'scope_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'all_variants_scope.g.dart';

@JsonSerializable(includeIfNull: false)
class AllVariantsScope extends Scope {
  const AllVariantsScope({
    required super.cardType,
    required super.cardId,
    required super.costs,
  }) : super(scopeType: ScopeType.all_variants);

  factory AllVariantsScope.fromJson(Map<String, dynamic> json) =>
      _$AllVariantsScopeFromJson(json);

  // \todo Like separate template builder?
  factory AllVariantsScope.fromJsonWithCard(
    CardType cardType,
    String cardId,
    Map<String, dynamic> json,
  ) {
    final jsonCosts = (json['costs'] ?? <dynamic>[]) as List<dynamic>;
    final costs = <Cost>[];
    for (final o in jsonCosts) {
      if (o is! Map<String, dynamic>) {
        throw 'Should be map. Received: `$o`.';
      }

      if (needIgnoreJsonKey(o, 'cost')) {
        Fimber.w('Excluded `$o` because ID has ignore prefix.');
        continue;
      }

      if (C.isApple) {
        final keyCost = (o['cost'] ?? '') as String;
        final costType = EnumToString.fromString(CostType.values, keyCost) ??
            CostType.undefined;
        if (C.ignoreCostTypesForApple.contains(costType)) {
          Fimber.w('Excluded `$o` because'
              ' C.ignoreCostTypesForApple contains `${costType.name}`.');
          continue;
        }
      }

      o['card_type'] = EnumToString.convertToString(cardType);
      o['card_id'] = cardId;
      o['scope_type'] = EnumToString.convertToString(ScopeType.all_variants);
      final cost = CostFactory.fromJsonCard(o);
      costs.add(cost);
      if (C.debugBloc) {
        Fimber.i('Added `$cost`.');
      }
    }

    return AllVariantsScope(cardType: cardType, cardId: cardId, costs: costs);
  }

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$AllVariantsScopeToJson(this));
}
