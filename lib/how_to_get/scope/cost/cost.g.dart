// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
      'card_type': _$CardTypeEnumMap[instance.cardType],
      'card_id': instance.cardId,
      'scope_type': _$ScopeTypeEnumMap[instance.scopeType],
      'cost': _$CostTypeEnumMap[instance.costType],
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

const _$CostTypeEnumMap = {
  CostType.undefined: 'undefined',
  CostType.get_free: 'get_free',
  CostType.purchase: 'purchase',
  CostType.rate_app: 'rate_app',
  CostType.subscribe_store: 'subscribe_store',
  CostType.subscribe_telegram: 'subscribe_telegram',
  CostType.waiting: 'waiting',
};
