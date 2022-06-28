import 'package:api_happiness/api_happiness.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../card_aware.dart';
import '../../../../card_checker.dart';
import '../../../../config.dart';
import '../../../../extensions/card_aware_json_extension.dart';
import '../../../app_file_managers.dart';
import '../../preview_card.dart';
import 'card_event.dart';
import 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final PreviewCard previewCard;
  final CardAware aware;

  CardBloc({required this.previewCard, required this.aware})
      : super(const InitCardState()) {
    on<CheckingCardEvent>(_onChecking);
  }

  void _onChecking(
    CheckingCardEvent event,
    Emitter<CardState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    // \test
    await pause();

    if (state is CheckingCardState) {
      // skip, we are checking now
      return;
    }

    if (state is! InitCardState) {
      Fimber.w('Unaccepted state for checking. State: `$state`.');
      return;
    }

    emit(const CheckingCardState());
    if (C.debugBloc) {
      Fimber.i('Checking card `${previewCard.id}`...');
    }

    if (previewCard.type == CardType.picture) {
      final checker = CardChecker(cardId: previewCard.id, aware: aware);
      final hasInLocalAssets = await checker.hasInLocalAssets(previewCard);

      var hasInLocalAssetsOrDownloadedFromCloud = hasInLocalAssets;
      if (!hasInLocalAssetsOrDownloadedFromCloud) {
        hasInLocalAssetsOrDownloadedFromCloud =
            await checker.hasInDownloadedFromCloud(previewCard);
      }

      var hasInCloud = hasInLocalAssetsOrDownloadedFromCloud;
      if (!hasInCloud) {
        hasInCloud = await checker.hasInCloud(previewCard);
      }

      if (!hasInLocalAssets &&
          !hasInLocalAssetsOrDownloadedFromCloud &&
          !hasInCloud) {
        emit(FailureCardState(
          message: 'Card `${previewCard.id}` with aware ${aware.json}'
              ' not found in local and cloud.'
              ' Verify the list `compositions` into the'
              ' `${previewCard.pathToAbout}`'
              ' and JSON-files into the folder'
              ' `${C.compositionsFolder}`.'
              ' These lists must match.',
        ));
        return;
      }

      if (!hasInLocalAssets &&
          !hasInLocalAssetsOrDownloadedFromCloud &&
          hasInCloud) {
        // preloading archived data
        emit(const DownloadingCardState());
        await warmUp();
      }
    }

    emit(const ReadyToShowCardState());
  }

  Future<void> warmUp() async {
    // we have guarantees that an archive with a name from this available
    // scales exists for this [cardId]
    final bestScale = previewCard.bestScale(aware);
    final pathToArchive = previewCard.pathToElementsBestScaleArchive(bestScale);
    if (C.debugBloc) {
      Fimber.i('Start warm up by the file `$pathToArchive`...');
    }
    final fm = AppFileManagerLocalPriority();
    await fm.warmUp(pathToArchive);
    if (C.debugBloc) {
      Fimber.i('Completed warm up by the file `$pathToArchive`.');
    }
  }
}
