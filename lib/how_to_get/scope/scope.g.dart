// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ScopeToJson(Scope instance) => <String, dynamic>{
      'card_type': _$CardTypeEnumMap[instance.cardType],
      'card_id': instance.cardId,
      'costs': instance.costs,
      'scope': _$ScopeTypeEnumMap[instance.scopeType],
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
