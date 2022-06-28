import 'package:api_happiness/api_happiness.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';

import '../app_file_managers.dart';
import '../card_aware.dart';
import '../config.dart';
import '../how_to_get/how_to_get.dart';
import 'card/logic/card_factory.dart';

/// Localized source (JSON) for card.
class PreviewCard extends Equatable {
  final Map<String, dynamic> json;

  CardType get type {
    final keyType = (json['type'] ?? '') as String;
    return EnumToString.fromString(CardType.values, keyType) ??
        CardType.undefined;
  }

  String get id => (json['id'] ?? '') as String;

  Map<String, dynamic> get aboutJson => json['about'] as Map<String, dynamic>;

  AboutCard get about => AboutCard.fromJson(aboutJson);

  HowToGet get howToGet => HowToGet.fromJsonCard(json);

  bool get isFree => howToGet.isFree;

  /// For order.
  int get weight => (json['weight'] ?? 1) as int;

  String get pathToAbout => CardFactory.commonPath(detectFolder(type), id);

  String get pathToAboutLocalized =>
      CardFactory.localizedPath(detectFolder(type), id);

  /// \see [CardAware.bestScale]
  String pathToElementsBestScaleArchive(int bestScale) {
    final folder = pathToElementsBestScaleFolder(bestScale);
    return '${folder.substring(0, folder.length - 1)}.zip';
  }

  /// \see [CardAware.bestScale]
  String pathToElementsBestScaleFolder(int bestScale) =>
      buildElementsPathBestScaleFolder(id, type, bestScale);

  /// \see [CardAware.bestScale]
  String pathToDetectExistsFolderFile(String folder) =>
      '${buildElementsPathFolder(id, type)}'
      '${C.detectExistsFolderFile(folder)}';

  String get rootPath => buildRootPath(id, type);

  static String buildRootPath(String id, CardType type) =>
      '${C.assetsFolder}/${detectFolder(type)}/$id/';

  static String buildElementsPathBestScaleFolder(
    String id,
    CardType type,
    int bestScale,
  ) =>
      '${buildElementsPathFolder(id, type)}$bestScale/';

  static String buildElementsPathFolder(
    String id,
    CardType type,
  ) =>
      '${buildRootPath(id, type)}${C.elementsFolder}/';

  // ex: assets/picture_cards/fairy/elements/50/bird.webp`
  String pathToSpriteInRoot(
    int bestScale,
    String spriteName,
  ) =>
      '${pathToElementsBestScaleFolder(bestScale)}'
      '$spriteName.${C.allowedImageFileExtension}';

  // ex: assets/picture_cards/fairy/elements/50/bird_1.mp3`
  String pathToSoundInRoot(
    int bestScale,
    String name,
    int i,
  ) =>
      buildPathToSoundInRoot(id, type, bestScale, name, i);

  static String buildPathToSoundInRoot(
    String id,
    CardType type,
    int bestScale,
    String name,
    int i,
  ) =>
      '${buildElementsPathBestScaleFolder(id, type, bestScale)}'
      '${name}_$i.${C.allowedAudioFileExtension}';

  // ex: assets/picture_cards/fairy/elements/50/owl/`
  String pathToAnimationInRootFolder(
    int bestScale,
    String name,
  ) =>
      '${pathToElementsBestScaleFolder(bestScale)}'
      '$name/';

  // ex: assets/picture_cards/fairy/elements/50/bird/bird.webp`
  String pathToSpriteInRootFolder(
    int bestScale,
    String name,
  ) =>
      '${pathToElementsBestScaleFolder(bestScale)}'
      '$name/'
      '$name.${C.allowedImageFileExtension}';

  // ex: assets/picture_cards/fairy/elements/50/bird/bird_1.mp3`
  String pathToSoundInRootFolder(
    int bestScale,
    String name,
    int i,
  ) =>
      buildPathToSoundInRootFolder(id, type, bestScale, name, i);

  static String buildPathToSoundInRootFolder(
    String id,
    CardType type,
    int bestScale,
    String name,
    int i,
  ) =>
      '${buildElementsPathBestScaleFolder(id, type, bestScale)}'
      '$name/'
      '${name}_$i.${C.allowedAudioFileExtension}';

  // ex: assets/picture_cards/fairy/elements/50/owl/tap/`
  String pathToAnimationInRootFolderState(
    int bestScale,
    String name,
    String stateName,
  ) =>
      '${pathToElementsBestScaleFolder(bestScale)}'
      '$name/$stateName/';

  // ex: assets/picture_cards/fairy/elements/50/bird/tap/bird.webp`
  String pathToSpriteInRootFolderState(
    int bestScale,
    String name,
    String stateName,
  ) =>
      '${pathToElementsBestScaleFolder(bestScale)}'
      '$name/$stateName/'
      '$name.${C.allowedImageFileExtension}';

  // ex: assets/picture_cards/fairy/elements/50/bird/tap/bird_1.mp3`
  String pathToSoundInRootFolderState(
    int bestScale,
    String name,
    String stateName,
    int i,
  ) =>
      buildPathToSoundInRootFolderState(
        id,
        type,
        bestScale,
        name,
        stateName,
        i,
      );

  static String buildPathToSoundInRootFolderState(
    String id,
    CardType type,
    int bestScale,
    String name,
    String stateName,
    int i,
  ) =>
      '${buildElementsPathBestScaleFolder(id, type, bestScale)}'
      '$name/$stateName/'
      '${name}_$i.${C.allowedAudioFileExtension}';

  // ex: assets/picture_cards/fairy/elements/50/owl/idle/`
  String pathToAnimationInRootFolderIdleState(
    int bestScale,
    String name,
  ) =>
      pathToAnimationInRootFolderState(bestScale, name, 'idle');

  // ex: assets/picture_cards/fairy/elements/50/bird/idle/bird.webp`
  String pathToSpriteInRootFolderIdleState(
    int bestScale,
    String name,
  ) =>
      pathToSpriteInRootFolderState(bestScale, name, 'idle');

  // ex: assets/picture_cards/fairy/elements/50/bird/idle/bird_1.mp3`
  String pathToSoundInRootFolderIdleState(
    int bestScale,
    String name,
    int i,
  ) =>
      buildPathToSoundInRootFolderIdleState(id, type, bestScale, name, i);

  static String buildPathToSoundInRootFolderIdleState(
    String id,
    CardType type,
    int bestScale,
    String name,
    int i,
  ) =>
      buildPathToSoundInRootFolderState(id, type, bestScale, name, 'idle', i);

  static String animationAtlasFile(String name) => '$name.atlas';

  static String animationSkeletonFile(String name) => '$name.json';

  static String animationTextureFile(String name) =>
      '$name.${C.allowedImageFileExtension}';

  Future<String> animationPathPrefix(
    String name,
    int bestScale,
    String stateName,
  ) async {
    final fm = AppFileManagerLocalPriority();

    // sequence of paths for find animation by analogy with load sounds
    final paths = <String>[
      if (stateName.isNotEmpty)
        pathToAnimationInRootFolderState(bestScale, name, stateName),
      pathToAnimationInRootFolderIdleState(bestScale, name),
      pathToAnimationInRootFolder(bestScale, name),
    ];
    final atlasFile = animationAtlasFile(name);
    for (final pathFolder in paths) {
      // detect available animation by file `*.atlas`
      final path = '$pathFolder$atlasFile';
      if (C.debugAnimation) {
        Fimber.i('Look at `$name` into the file `$path`...');
      }
      if (await fm.exists(path)) {
        final file = await fm.loadFile(path);
        if (file != null) {
          return pathFolder;
        }

        if (C.debugAnimation) {
          Fimber.i('File `$path` exists, but not downloaded.');
        }
      }
      if (C.debugAnimation) {
        Fimber.i("File `$path` doesn't exists.");
      }
    }

    Fimber.w('Not found an animation `$name` with best scale $bestScale'
        ' for the ${type.name} `$id`.');

    return '';
  }

  // ex: assets/picture_cards/fairy/previews/4to3/256x192/canvas.webp`
  List<String> get previewsPaths => about.previews
      .map((p) => '$rootPath${C.previewsFolder}/'
          '$p.${C.previewFileExtension}')
      .toList();

  String get folder => detectFolder(type);

  static String detectFolder(CardType type) =>
      type == CardType.undefined ? '' : '${type.name}${C.cardsFolderSuffix}';

  int bestScale(CardAware aware) =>
      aware.bestScreenScale(about.originalSize, about.availableScales);

  PreviewCard({required this.json}) : assert(json.isNotEmpty);

  /// The localized preview card by ID.
  static Future<PreviewCard?> fromId(String cardId) async {
    final js = await CardFactory.cardJsons();
    for (final json in js) {
      final id = (json['id'] ?? '') as String;
      if (id == cardId) {
        return PreviewCard.fromElementInCardsJson(json);
      }
    }

    return null;
  }

  /// The localized preview card from one JSON element in `cards.json`.
  static Future<PreviewCard> fromElementInCardsJson(
    Map<String, dynamic> jsonCardFromCardsFile,
  ) async {
    final keyType = (jsonCardFromCardsFile['type'] ?? '') as String;
    final type =
        EnumToString.fromString(CardType.values, keyType) ?? CardType.undefined;
    final id = (jsonCardFromCardsFile['id'] ?? '') as String;

    final fm = AppFileManagerLocalPriority();
    final cardFolder = detectFolder(type);

    // common data `about.json`
    final commonAboutPath = CardFactory.commonPath(cardFolder, id);
    if (!await fm.exists(commonAboutPath)) {
      throw 'Common about-file expected to see by path `$commonAboutPath`.';
    }

    if (C.debugCardPath) {
      Fimber.i('getting json from local storage priority'
          ' by path `$commonAboutPath`...');
    }
    final commonAboutData = await fm.loadString(commonAboutPath) ?? '';
    if (C.debugCardPath) {
      Fimber.i('string from `$commonAboutPath`:\n`$commonAboutData`');
    }
    if (commonAboutData.isEmpty) {
      throw 'Not found data by path `$commonAboutPath`.';
    }

    final commonAboutJson = commonAboutData.jsonMap;

    // localized data `about`
    final localizedAboutPath = CardFactory.localizedPath(cardFolder, id);
    if (!await fm.exists(localizedAboutPath)) {
      throw 'Localized about-file expected to see by path `$localizedAboutPath`.';
    }

    if (C.debugCardPath) {
      Fimber.i('getting json from local storage priority'
          ' by path `$localizedAboutPath`...');
    }
    final localizedAboutData = await fm.loadString(localizedAboutPath) ?? '';
    if (C.debugCardPath) {
      Fimber.i('string from `$localizedAboutPath`:\n`$localizedAboutData`');
    }
    if (localizedAboutData.isEmpty) {
      throw 'Not found data by path `$localizedAboutPath`.';
    }

    final localizedAboutJson = localizedAboutData.jsonMap;

    final commonAboutId = (commonAboutJson['id'] ?? '') as String;
    final localizedAboutId = (localizedAboutJson['id'] ?? '') as String;
    if (commonAboutId != localizedAboutId && localizedAboutId.isNotEmpty) {
      throw 'Different IDs into the `$commonAboutJson`'
          ' and `$localizedAboutPath`:'
          ' `$commonAboutId` != `$localizedAboutId`.';
    }

    // merge common and localized data
    final jsonAboutCombined = commonAboutJson..addAll(localizedAboutJson);

    final jsonCombined = Map<String, dynamic>.of(jsonCardFromCardsFile);
    jsonCombined['about'] = jsonAboutCombined;

    return PreviewCard(json: jsonCombined);
  }

  Map<String, dynamic> toJson() => json;

  @override
  List<Object?> get props => [json];
}
