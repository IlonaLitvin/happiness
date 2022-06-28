// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'later_about_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaterAboutCard _$LaterAboutCardFromJson(Map<String, dynamic> json) =>
    LaterAboutCard(
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
      sequence: json['sequence'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$LaterAboutCardToJson(LaterAboutCard instance) {
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
  val['sequence'] = instance.sequence;
  return val;
}
