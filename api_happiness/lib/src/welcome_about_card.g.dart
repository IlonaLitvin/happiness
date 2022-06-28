// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_about_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WelcomeAboutCard _$WelcomeAboutCardFromJson(Map<String, dynamic> json) =>
    WelcomeAboutCard(
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
      title1: json['title1'] as String,
      title2: json['title2'] as String,
      subtitle: json['subtitle'] as String,
      privacy: json['privacy'] as Map<String, dynamic>?,
      terms: json['terms'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$WelcomeAboutCardToJson(WelcomeAboutCard instance) {
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
  val['title1'] = instance.title1;
  val['title2'] = instance.title2;
  val['subtitle'] = instance.subtitle;
  writeNotNull('privacy', instance.privacy);
  writeNotNull('terms', instance.terms);
  return val;
}
