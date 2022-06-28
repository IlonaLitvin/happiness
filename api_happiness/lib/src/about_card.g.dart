// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutCard _$AboutCardFromJson(Map<String, dynamic> json) => AboutCard(
      type: $enumDecode(_$CardTypeEnumMap, json['type']),
      id: json['id'] as String,
      originalSize: const Vector2IntJsonConverter()
          .fromJson(json['original_size'] as List),
      compositions: (json['compositions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      elements:
          (json['elements'] as List<dynamic>).map((e) => e as int).toList(),
      previews:
          (json['previews'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AboutCardToJson(AboutCard instance) {
  final val = <String, dynamic>{
    'type': _$CardTypeEnumMap[instance.type],
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('original_size',
      const Vector2IntJsonConverter().toJson(instance.originalSize));
  val['compositions'] = instance.compositions;
  val['elements'] = instance.elements;
  val['previews'] = instance.previews;
  return val;
}

const _$CardTypeEnumMap = {
  CardType.undefined: 'undefined',
  CardType.later: 'later',
  CardType.picture: 'picture',
  CardType.welcome: 'welcome',
};
