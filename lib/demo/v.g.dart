// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V _$VFromJson(Map<String, dynamic> json) => V(
      name: json['name'] as String,
      position: const _Vector2Converter().fromJson(json['position'] as List),
    );

Map<String, dynamic> _$VToJson(V instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('position', const _Vector2Converter().toJson(instance.position));
  return val;
}
