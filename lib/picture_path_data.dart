import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/widgets.dart';

// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'app_file_managers.dart';
import 'card_aware.dart';
import 'config.dart';
import 'service_locator.dart';

/// Path to file and aspect size for this file.
typedef PathAspectSize = MapEntry<String, Vector2>;

@immutable
class PicturePathData {
  final String name;
  final CardAware aware;

  Config get config => sl.get<Config>();

  PicturePathData(this.name, this.aware) {
    if (C.debugCardPath) {
      Fimber.i('detecting path for'
          ' picture `$name`'
          ' screen ${aware.screenSize()}'
          ' ${aware.screenOrientation()}'
          '...');
    }
  }

  /// \return JSON-data with help [AppFileManagerLocalPriority].
  Future<Map<String, dynamic>> dataComposition(
    List<String> availableCompositions,
  ) async {
    final preferredScreenAspectSize = aware.preferredScreenAspectSize();
    final preferredScreenAspectSuffix =
        preferredScreenAspectSize.likeAspectSizeString;
    if (C.debugCardPath) {
      Fimber.i('get dataComposition for'
          ' aspectSize $preferredScreenAspectSize'
          ' ${aware.screenOrientation()}...'
          " If you can't find your new resolution add it to"
          ' `CardAware.aspectSizeList`.');
    }

    // first best available orientation
    final aspectSizes = aware.preferredScreenAspectSizes().values;
    for (final aspectSize in aspectSizes) {
      final aspectSuffix = aspectSize.likeAspectSizeString;
      final path = pathToComposition(aspectSuffix);
      if (C.debugCardPath) {
        Fimber.i('path for aspectSuffix `$aspectSuffix` is `$path`');
      }

      // some compositions can be contain prefix `-`, it's OK
      if (availableCompositions.contains(aspectSuffix)) {
        final fm = AppFileManagerLocalPriority();
        final s = await fm.loadString(path) ?? '';
        if (C.debugBloc) {
          Fimber.i('string from `$path`:\n`$s`');
        }
        return s.jsonMap;
      }
    }

    if (C.debugCardPath) {
      Fimber.w('Path for `$preferredScreenAspectSuffix` is not found.'
          ' Verify ${C.compositionsFolder} into the `about.json`.');
    }

    return <String, dynamic>{};
  }

  /// \see PictureCheckerAspectSizeOnStringExtension
  static String fileComposition(String aspectSizeSuffix) =>
      '$aspectSizeSuffix.${C.compositionFileExtension}';

  String pathToComposition(String aspectSuffix) =>
      '${C.assetsFolder}/${C.pictureCardsFolder}/'
      '$name/${C.compositionsFolder}/'
      '${fileComposition(aspectSuffix)}';
}
