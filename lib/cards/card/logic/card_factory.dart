import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';

import '../../../active_localization.dart';
import '../../../app_file_managers.dart';
import '../../../config.dart';
import '../../../service_locator.dart';

// ignore: avoid_classes_with_only_static_members
class CardFactory {
  /// The list of all card IDs from `cards.json` sorted by abc when enabled
  /// [abcSort] and without excluded IDs when enabled [ignoreExcluded].
  /// Load priority: 1) cloud 2) local.
  static Future<List<String>> cardIds({
    bool ignoreExcluded = true,
    bool abcSort = true,
  }) async {
    final r = <String>[];
    final js = await cardJsons(ignoreExcluded: ignoreExcluded);
    for (final json in js) {
      final id = (json['id'] ?? '') as String;
      r.add(id);
    }

    if (abcSort) {
      r.sort();
    }

    return r;
  }

  /// The list of all card JSONs from `cards.json` without excluded IDs when
  /// enabled [ignoreExcluded].
  /// Load priority: 1) cloud 2) local.
  static Future<List<Map<String, dynamic>>> cardJsons({
    bool ignoreExcluded = true,
  }) async {
    final fm = AppFileManagerCloudPriorityWithoutArchive();

    const path = '${C.assetsFolder}/${C.cardsFile}';
    if (C.debugBloc) {
      Fimber.i('getting json from cloud storage priority by path `$path`...');
    }
    if (!await fm.exists(path)) {
      throw 'Common about-file expected to see by path `$path`.';
    }

    final s = await fm.loadString(path) ?? '';
    if (C.debugBloc) {
      Fimber.i('string from `$path`:\n`$s`');
    }
    if (s.isEmpty) {
      return [];
    }

    final js = s.jsonList;

    final r = <Map<String, dynamic>>[];
    for (final jsonCardFromCardsFile in js) {
      if (jsonCardFromCardsFile is! Map<String, dynamic>) {
        throw 'Should be map. Received: `$jsonCardFromCardsFile`.';
      }

      final id = (jsonCardFromCardsFile['id'] ?? '') as String;
      if (id.isEmpty) {
        throw 'ID should be not empty.';
      }

      if (ignoreExcluded && needIgnore(id)) {
        Fimber.w('Excluded `$jsonCardFromCardsFile` because ID is ignore.');
        continue;
      }

      r.add(jsonCardFromCardsFile);
    }

    return r;
  }

  static String get languageCode =>
      sl.get<ActiveLocalization>().currentLocale.languageCode;

  static String commonPath(String folder, String id) =>
      '${C.assetsFolder}/$folder/$id/${C.aboutFolder}/'
      '${C.aboutFileName}.${C.aboutFileExtension}';

  static String localizedPath(String folder, String id) =>
      '${C.assetsFolder}/$folder/$id/${C.aboutFolder}/'
      '${C.aboutFileName}_$languageCode.${C.aboutFileExtension}';
}
