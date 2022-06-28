// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scale_in_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScaleInOut _$ScaleInOutFromJson(Map<String, dynamic> json) => ScaleInOut(
      duration: (json['duration'] as num?)?.toDouble() ?? 1.0,
      scale: (json['scale'] as num?)?.toDouble() ?? 1.2,
      curve: json['curve'] == null
          ? CurveJsonConverter.defaultCurve
          : const CurveJsonConverter().fromJson(json['curve'] as String?),
    );

Map<String, dynamic> _$ScaleInOutToJson(ScaleInOut instance) {
  final val = <String, dynamic>{
    'duration': instance.duration,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('curve', const CurveJsonConverter().toJson(instance.curve));
  val['scale'] = instance.scale;
  return val;
}
