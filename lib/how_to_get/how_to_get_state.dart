import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'how_to_get_state.g.dart';

enum HowToGetStateEnum {
  init,
  completed,
}

@JsonSerializable(
    ignoreUnannotated: true, includeIfNull: false, createFactory: false)
abstract class HowToGetState extends Equatable {
  @JsonKey()
  final HowToGetStateEnum state;

  @JsonKey()
  final String cardId;

  const HowToGetState({required this.state, required this.cardId});

  factory HowToGetState.fromJson(Map<String, dynamic> json) {
    final keyState = (json['state'] ?? '') as String;
    final state = EnumToString.fromString(HowToGetStateEnum.values, keyState) ??
        HowToGetStateEnum.init;

    final cardId = (json['cardId'] ?? String) as String;

    if (state == HowToGetStateEnum.completed) {
      return CompletedHowToGetState(cardId: cardId);
    }

    return InitHowToGetState(cardId: cardId);
  }

  @override
  List<Object?> get props => toJson().values.toList();

  Map<String, dynamic> toJson() => _$HowToGetStateToJson(this);
}

@JsonSerializable(includeIfNull: false)
class InitHowToGetState extends HowToGetState {
  const InitHowToGetState({required super.cardId})
      : super(state: HowToGetStateEnum.init);

  factory InitHowToGetState.fromJson(Map<String, dynamic> json) =>
      _$InitHowToGetStateFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$InitHowToGetStateToJson(this));
}

@JsonSerializable(includeIfNull: false)
class CompletedHowToGetState extends HowToGetState {
  const CompletedHowToGetState({required super.cardId})
      : super(state: HowToGetStateEnum.completed);

  factory CompletedHowToGetState.fromJson(Map<String, dynamic> json) =>
      _$CompletedHowToGetStateFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$CompletedHowToGetStateToJson(this));
}

@JsonSerializable(includeIfNull: false)
class ShowMessageHowToGetState extends HowToGetState {
  // \todo Add Json converter for serialize [PurchaseState]?
  final String purchaseStateLikeString;

  /// \warning Saved and recovered like [HowToGetStateEnum.init].
  const ShowMessageHowToGetState({
    required this.purchaseStateLikeString,
    required super.cardId,
  }) : super(state: HowToGetStateEnum.init);

  factory ShowMessageHowToGetState.fromJson(Map<String, dynamic> json) =>
      _$ShowMessageHowToGetStateFromJson(json);

  /// Generate unique props for emit state to BLoC even with the same message.
  @override
  List<Object?> get props => [
        ...super.props,
        purchaseStateLikeString,
        DateTime.now(),
      ];

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$ShowMessageHowToGetStateToJson(this));
}
