// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welement_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WelementSource _$WelementSourceFromJson(Map<String, dynamic> json) =>
    WelementSource(
      name: json['name'] as String,
      isPartBackground: json['part_background'] as bool?,
      position: json['position'],
      anchor: const AnchorJsonConverter().fromJson(json['anchor'] as String?),
      sm: json['sm'] == null
          ? null
          : StateMachineData.fromJson(json['sm'] as Map<String, dynamic>),
      isVisible: json['visible'] as bool?,
      isMute: json['mute'] as bool?,
      scale: (json['scale'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WelementSourceToJson(WelementSource instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'part_background': instance.isPartBackground,
    'position': instance.position,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('anchor', const AnchorJsonConverter().toJson(instance.anchor));
  val['sm'] = instance.sm;
  val['visible'] = instance.isVisible;
  val['mute'] = instance.isMute;
  val['scale'] = instance.scale;
  return val;
}
