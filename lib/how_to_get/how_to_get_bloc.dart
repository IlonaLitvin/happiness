import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../config.dart';
import '../purchase/purchase_state.dart';
import 'how_to_get_event.dart';
import 'how_to_get_state.dart';

class HowToGetBloc extends HydratedBloc<HowToGetEvent, HowToGetState> {
  final String cardId;

  HowToGetBloc({required this.cardId})
      : super(InitHowToGetState(cardId: cardId)) {
    on<CompletedHowToGetEvent>(_onCompleted);
    on<UpdatedPurchasesHowToGetEvent>(_onUpdatedPurchases);
  }

  @override
  String get id => cardId;

  @override
  HowToGetState fromJson(Map<String, dynamic> json) =>
      HowToGetState.fromJson(json);

  @override
  Map<String, dynamic> toJson(HowToGetState state) => state.toJson();

  void _onCompleted(
    CompletedHowToGetEvent event,
    Emitter<HowToGetState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    // \test
    await pause();

    emit(CompletedHowToGetState(cardId: event.cardId));
  }

  void _onUpdatedPurchases(
    UpdatedPurchasesHowToGetEvent event,
    Emitter<HowToGetState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    // \test
    await pause();

    final purchaseBloc = event.purchaseBloc;
    final purchaseState = purchaseBloc.state;
    if (C.debugBloc) {
      Fimber.i('purchaseState $purchaseState');
    }

    if (purchaseState is AlreadyProAccessPurchaseState ||
        purchaseState is SuccessSubscribedPurchaseState ||
        purchaseState is SuccessRestoredPurchaseState) {
      emit(CompletedHowToGetState(cardId: event.cardId));
    } else {
      emit(ShowMessageHowToGetState(
        cardId: event.cardId,
        purchaseStateLikeString: purchaseState.runtimeType.toString(),
      ));
    }
  }
}
