// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grey_to_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GreyToColor _$GreyToColorFromJson(Map<String, dynamic> json) => GreyToColor(
      duration: (json['duration'] as num?)?.toDouble() ?? 1.0,
      curve: json['curve'] == null
          ? CurveJsonConverter.defaultCurve
          : const CurveJsonConverter().fromJson(json['curve'] as String?),
    );

Map<String, dynamic> _$GreyToColorToJson(GreyToColor instance) {
  final val = <String, dynamic>{
    'duration': instance.duration,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('curve', const CurveJsonConverter().toJson(instance.curve));
  return val;
}
