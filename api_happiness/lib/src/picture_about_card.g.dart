// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_about_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PictureAboutCard _$PictureAboutCardFromJson(Map<String, dynamic> json) =>
    PictureAboutCard(
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
      name: json['name'] as String,
      masterminds: (json['masterminds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      artists:
          (json['artists'] as List<dynamic>).map((e) => e as String).toList(),
      animators:
          (json['animators'] as List<dynamic>).map((e) => e as String).toList(),
      thanks:
          (json['thanks'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PictureAboutCardToJson(PictureAboutCard instance) {
  final val = <String, dynamic>{
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
  val['name'] = instance.name;
  val['masterminds'] = instance.masterminds;
  val['artists'] = instance.artists;
  val['animators'] = instance.animators;
  val['thanks'] = instance.thanks;
  return val;
}
