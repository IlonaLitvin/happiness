// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_to_grey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorToGrey _$ColorToGreyFromJson(Map<String, dynamic> json) => ColorToGrey(
      duration: (json['duration'] as num?)?.toDouble() ?? 1.0,
      curve: json['curve'] == null
          ? CurveJsonConverter.defaultCurve
          : const CurveJsonConverter().fromJson(json['curve'] as String?),
    );

Map<String, dynamic> _$ColorToGreyToJson(ColorToGrey instance) {
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
