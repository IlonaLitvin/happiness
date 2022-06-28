import 'package:cross_file_manager/cross_file_manager.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/extensions.dart';

import 'app_file_managers.dart';
import 'card_aware.dart';
import 'cards/preview_card.dart';
import 'config.dart';
import 'service_locator.dart';

class CardChecker {
  final String cardId;
  final CardAware aware;

  AppFileManagerLocalPriority get fm => AppFileManagerLocalPriority();

  Config get config => sl.get<Config>();

  const CardChecker({
    required this.cardId,
    required this.aware,
  }) : assert(cardId.length > 0);

  Future<bool> hasInLocalAssets(PreviewCard previewCard) async => _hasIn(
        'local assets',
        previewCard,
        (String path) => fm.exists(path, loaders: const [PlainAssetsLoader()]),
      );

  Future<bool> hasInDownloadedFromCloud(PreviewCard previewCard) async =>
      _hasIn(
        'downloaded from cloud',
        previewCard,
        (String path) => fm.existsInCache(
          path,
          loaders: C.enableClouds ? const [PlainFirebaseLoader()] : [],
        ),
      );

  Future<bool> hasInCloud(PreviewCard previewCard) async => _hasIn(
        'cloud',
        previewCard,
        (String path) => fm.exists(
          path,
          loaders: C.enableClouds ? const [PlainFirebaseLoader()] : [],
        ),
      );

  Future<bool> _hasIn(
    String where,
    PreviewCard previewCard,
    Future<bool> Function(String path) fnHasIn,
  ) async {
    // we have guarantees that an archive with a name from this available
    // scales exists for this [cardId]
    final bestScale = previewCard.bestScale(aware);
    final path = previewCard.pathToDetectExistsFolderFile(bestScale.toString());
    if (C.debugCardChecker) {
      Fimber.i('path to detect a best scale is `$path`');
    }

    final exists = await fnHasIn(path);
    if (C.debugCardChecker) {
      Fimber.i('exists `$path` into the `$where`? $exists');
    }

    return exists;
  }
}

extension PictureCheckerOnStringExtension on String {
  bool get containsAspectSize => indexOf(RegExp(r'_\d+to\d+\.')) != -1;

  bool get containsSpaces => indexOf(RegExp(r'\s+')) != -1;

  bool get isPathToComposition {
    if (containsSpaces) {
      return false;
    }

    const s = r'\d+to\d+\.' + C.compositionFileExtension + r'$';
    if (contains(RegExp('^$s'))) {
      return true;
    }

    if (contains(RegExp('/$s'))) {
      return true;
    }

    return false;
  }

  bool get isPathToDownloadedInfo =>
      !containsSpaces &&
      contains(RegExp(C.downloadedInfoFileName +
          r'\.' +
          C.downloadedInfoFileExtension +
          r'$'));

  bool get isPathToPreview =>
      !containsSpaces &&
      contains(
          RegExp(r'\d+to\d+\/\d+x\d+\/.*' + C.previewFileExtension + r'$'));

  /// \see [CardAwareAspectSizeOnStringExtension.likeAspectSize]
  Vector2 get extractAspectSize {
    if (!containsAspectSize) {
      return Vector2.zero();
    }

    final from = lastIndexOf('_');
    final to = lastIndexOf('.');
    if (from == -1 || to == -1) {
      return Vector2.zero();
    }

    return substring(from + 1, to).likeAspectSize;
  }
}
