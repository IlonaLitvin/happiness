// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_variants_scope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllVariantsScope _$AllVariantsScopeFromJson(Map<String, dynamic> json) =>
    AllVariantsScope(
      cardType: $enumDecode(_$CardTypeEnumMap, json['card_type']),
      cardId: json['card_id'] as String,
      costs: (json['costs'] as List<dynamic>)
          .map((e) => Cost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllVariantsScopeToJson(AllVariantsScope instance) =>
    <String, dynamic>{
      'card_type': _$CardTypeEnumMap[instance.cardType],
      'card_id': instance.cardId,
      'costs': instance.costs,
    };

const _$CardTypeEnumMap = {
  CardType.undefined: 'undefined',
  CardType.later: 'later',
  CardType.picture: 'picture',
  CardType.welcome: 'welcome',
};
