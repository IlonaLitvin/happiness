// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'how_to_get_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$HowToGetStateToJson(HowToGetState instance) =>
    <String, dynamic>{
      'state': _$HowToGetStateEnumEnumMap[instance.state],
      'cardId': instance.cardId,
    };

const _$HowToGetStateEnumEnumMap = {
  HowToGetStateEnum.init: 'init',
  HowToGetStateEnum.completed: 'completed',
};

InitHowToGetState _$InitHowToGetStateFromJson(Map<String, dynamic> json) =>
    InitHowToGetState(
      cardId: json['cardId'] as String,
    );

Map<String, dynamic> _$InitHowToGetStateToJson(InitHowToGetState instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
    };

CompletedHowToGetState _$CompletedHowToGetStateFromJson(
        Map<String, dynamic> json) =>
    CompletedHowToGetState(
      cardId: json['cardId'] as String,
    );

Map<String, dynamic> _$CompletedHowToGetStateToJson(
        CompletedHowToGetState instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
    };

ShowMessageHowToGetState _$ShowMessageHowToGetStateFromJson(
        Map<String, dynamic> json) =>
    ShowMessageHowToGetState(
      purchaseStateLikeString: json['purchaseStateLikeString'] as String,
      cardId: json['cardId'] as String,
    );

Map<String, dynamic> _$ShowMessageHowToGetStateToJson(
        ShowMessageHowToGetState instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'purchaseStateLikeString': instance.purchaseStateLikeString,
    };
