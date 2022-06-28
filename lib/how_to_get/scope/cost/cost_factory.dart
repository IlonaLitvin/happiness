import 'package:api_happiness/api_happiness.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:fimber/fimber.dart';

import '../scope_type.dart';
import 'cost.dart';
import 'cost_type.dart';
import 'get_free_cost.dart';
import 'purchase_cost.dart';
import 'rate_app_cost.dart';
import 'subscribe_store_cost.dart';
import 'subscribe_telegram_cost.dart';

typedef CostBuilderJson = Cost Function(
  CardType,
  String cardId,
  ScopeType scopeType,
  Map<String, dynamic> json,
);

// ignore: avoid_classes_with_only_static_members
class CostFactory {
  static Cost fromJsonCard(Map<String, dynamic> json) {
    final keyCardType = (json['card_type'] ?? '') as String;
    final cardType = EnumToString.fromString(CardType.values, keyCardType) ??
        CardType.undefined;

    final cardId = (json['card_id'] ?? '') as String;

    final keyScopeType = (json['scope_type'] ?? '') as String;
    final scopeType = EnumToString.fromString(ScopeType.values, keyScopeType) ??
        ScopeType.undefined;

    return CostFactory._fromJsonWithCard(cardType, cardId, scopeType, json);
  }

  static Cost _fromJsonWithCard(
    CardType cardType,
    String cardId,
    ScopeType scopeType,
    Map<String, dynamic> json,
  ) {
    assert(cardType != CardType.undefined);
    assert(cardId.isNotEmpty);

    final keyCost = (json['cost'] ?? '') as String;
    final costType =
        EnumToString.fromString(CostType.values, keyCost) ?? CostType.undefined;
    final builder = _detectBuilder(costType);
    Fimber.i('Found builder: $builder');
    if (builder == null) {
      throw 'Undefined builder for cost `${costType.name}`.';
    }

    return builder(cardType, cardId, scopeType, json);
  }

  static CostBuilderJson? _detectBuilder(CostType cost) =>
      const <CostType, CostBuilderJson>{
        CostType.get_free: GetFreeCost.fromJsonWithCard,
        CostType.purchase: PurchaseCost.fromJsonWithCard,
        CostType.rate_app: RateAppCost.fromJsonWithCard,
        CostType.subscribe_store: SubscribeStoreCost.fromJsonWithCard,
        CostType.subscribe_telegram: SubscribeTelegramCost.fromJsonWithCard,
        //CostType.waiting: WaitingCost.fromJson,
      }[cost];
}
