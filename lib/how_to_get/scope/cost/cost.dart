import 'package:api_happiness/api_happiness.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../../../active_localization.dart';
import '../../../app_text.dart';
import '../../../cards/cards_bloc.dart';
import '../../../cards/cards_event.dart';
import '../../../cards/preview_card.dart';
import '../../../config.dart';
import '../../how_to_get_bloc.dart';
import '../../how_to_get_event.dart';
import '../../how_to_get_state.dart';
import '../scope_type.dart';
import 'cost_factory.dart';
import 'cost_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'cost.g.dart';

@JsonSerializable(
    ignoreUnannotated: true, includeIfNull: false, createFactory: false)
abstract class Cost extends Equatable with Localization {
  @JsonKey(name: 'card_type')
  final CardType cardType;

  @JsonKey(name: 'card_id')
  final String cardId;

  @JsonKey(name: 'scope_type')
  final ScopeType scopeType;

  @JsonKey(name: 'cost')
  final CostType costType;

  const Cost({
    required this.cardType,
    required this.cardId,
    required this.scopeType,
    required this.costType,
  })  : assert(cardType != CardType.undefined),
        assert(cardId.length > 0),
        assert(scopeType != ScopeType.undefined),
        assert(costType != CostType.undefined);

  factory Cost.fromJson(Map<String, dynamic> json) =>
      CostFactory.fromJsonCard(json);

  String get textTitle;

  String get textButton;

  String get textWhenThisPreferred;

  Widget buildView(BuildContext context, PreviewCard previewCard) =>
      AppText('${toString()}\n${previewCard.toString()}');

  @protected
  void onPressSendCompleted(BuildContext context) {
    final bloc = context.read<HowToGetBloc>();
    if (C.debugPurchase) {
      Fimber.i('Send completed to bloc `$bloc`');
    }

    if (bloc.isClosed) {
      return;
    }

    final state = bloc.state;
    if (state is CompletedHowToGetState) {
      // ok, it's completed
      _updateCardState(context);
      return;
    }

    if (state is InitHowToGetState || state is ShowMessageHowToGetState) {
      // ok, we keep silent
      bloc.add(CompletedHowToGetEvent(cardId: bloc.cardId));
      _updateCardState(context);
      return;
    }

    Fimber.e('Unacceptable state `$state`.');
  }

  // \todo fine Update only current card.
  void _updateCardState(BuildContext context) =>
      context.read<CardsBloc>().add(const LoadingCardsEvent());

  @override
  List<Object?> get props => toJson().values.toList();

  Map<String, dynamic> toJson() => _$CostToJson(this);
}
