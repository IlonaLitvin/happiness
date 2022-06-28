import 'dart:async';

import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config.dart';
import 'card/logic/card_factory.dart';
import 'cards_event.dart';
import 'cards_state.dart';
import 'preview_card.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final List<PreviewCard> previewCards = [];

  CardsBloc() : super(const LoadingCardsState()) {
    on<LoadingCardsEvent>(_onLoading);
    on<NextCardsEvent>(_onNext);
  }

  void _onLoading(
    LoadingCardsEvent event,
    Emitter<CardsState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    // \test
    await pause();

    late final List<PreviewCard> loadedPreviewCards;
    try {
      loadedPreviewCards = await _loadPreviewCards();
    } catch (ex) {
      Fimber.e('', ex: ex);
      emit(FailureCardsState(message: ex));
      return;
    }

    if (loadedPreviewCards.isEmpty) {
      emit(const FailureCardsState(message: "Can't load the list of cards."));
      return;
    }

    previewCards
      ..clear()
      ..addAll(loadedPreviewCards);

    emit(const SuccessCardsState());
  }

  void _onNext(
    NextCardsEvent event,
    Emitter<CardsState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    emit(const NextCardsState());

    // add a pause for catch emitted state in the CardsView
    await pause(const Duration(milliseconds: 1200));

    emit(const SuccessCardsState());
  }

  /// Get IDs of cards only sorted by weight.
  Future<List<PreviewCard>> _loadPreviewCards() async {
    final r = <PreviewCard>[];
    final js = await CardFactory.cardJsons();
    for (final json in js) {
      final previewCard = await PreviewCard.fromElementInCardsJson(json);
      r.add(previewCard);
      if (C.debugBloc) {
        Fimber.i('Added `$previewCard`.');
      }
    }

    r.sort((a, b) => a.weight - b.weight);

    return r;
  }
}
