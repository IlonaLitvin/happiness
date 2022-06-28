// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_cost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseCost _$PurchaseCostFromJson(Map<String, dynamic> json) => PurchaseCost(
      cardType: $enumDecode(_$CardTypeEnumMap, json['card_type']),
      cardId: json['card_id'] as String,
      scopeType: $enumDecode(_$ScopeTypeEnumMap, json['scope_type']),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PurchaseCostToJson(PurchaseCost instance) =>
    <String, dynamic>{
      'card_type': _$CardTypeEnumMap[instance.cardType],
      'card_id': instance.cardId,
      'scope_type': _$ScopeTypeEnumMap[instance.scopeType],
      'price': instance.price,
    };

const _$CardTypeEnumMap = {
  CardType.undefined: 'undefined',
  CardType.later: 'later',
  CardType.picture: 'picture',
  CardType.welcome: 'welcome',
};

const _$ScopeTypeEnumMap = {
  ScopeType.undefined: 'undefined',
  ScopeType.all_variants: 'all_variants',
  ScopeType.spring: 'spring',
  ScopeType.summer: 'summer',
  ScopeType.autumn: 'autumn',
  ScopeType.winter: 'winter',
  ScopeType.morning: 'morning',
  ScopeType.midday: 'midday',
  ScopeType.evening: 'evening',
  ScopeType.night: 'night',
  ScopeType.blizzard: 'blizzard',
  ScopeType.rain: 'rain',
  ScopeType.snow: 'snow',
  ScopeType.sun: 'sun',
};
