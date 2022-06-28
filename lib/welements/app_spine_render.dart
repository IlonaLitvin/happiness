import 'package:fimber/fimber.dart';
import 'package:flame_spine/flame_spine.dart';

// ignore: depend_on_referenced_packages
import 'package:spine_core/spine_core.dart' as core;

// ignore: depend_on_referenced_packages
import 'package:spine_flutter/spine_flutter.dart';

import '../app_file_managers.dart';
import '../cards/preview_card.dart';
import '../config.dart';

/// Render loaded animation.
class AppSpineRender extends SpineRender {
  final PreviewCard previewCard;
  final int bestScale;

  final fm = AppFileManagerLocalPriority();

  AppSpineRender({
    required this.previewCard,
    required super.name,
    required this.bestScale,
    super.startAnimation,
    super.loop,
    super.pathPrefix,
    super.fit,
    super.playState,
  }) : assert(bestScale > 0);

  @override
  Future<SkeletonAnimation?> buildSkeleton() async {
    final pathPrefix =
        await previewCard.animationPathPrefix(name, bestScale, 'idle');
    final atlasFile = PreviewCard.animationAtlasFile(name);
    final skeletonFile = PreviewCard.animationSkeletonFile(name);

    final assets = <String, dynamic>{};
    final atlasRaw = await fm.loadString(pathPrefix + atlasFile);
    final jsonRaw = await fm.loadString(pathPrefix + skeletonFile);
    final futures = <Future<MapEntry<String, dynamic>>>[
      AssetLoader.loadText(pathPrefix + atlasFile, atlasRaw),
      AssetLoader.loadJson(pathPrefix + skeletonFile, jsonRaw),
    ];

    final textureFiles =
        await _appTextureFilesFromAtlas(pathPrefix + atlasFile);
    for (final textureFile in textureFiles) {
      final path = pathPrefix + textureFile;
      final loadedFile = await fm.loadFile(path);
      if (loadedFile == null) {
        Fimber.e("Can't load texture `$path`.");
        continue;
      }

      final textureRaw = loadedFile.readAsBytesSync();
      final entry = AssetLoader.loadTexture(path, textureRaw);
      futures.add(entry);
    }

    await Future.wait(futures).then(assets.addEntries).catchError((Object e) {
      Fimber.e("Couldn't add entries. $e");
    });

    final atlas = core.TextureAtlas(assets[pathPrefix + atlasFile] as String,
        (String? p) {
      Fimber.i('TextureAtlas `${pathPrefix + (p ?? '')}`');
      return assets[pathPrefix + (p ?? '')] as core.Texture;
    });
    final atlasLoader = core.AtlasAttachmentLoader(atlas);
    final skeletonJson = core.SkeletonJson(atlasLoader);
    final skeletonData = skeletonJson.readSkeletonData(
        assets[pathPrefix + skeletonFile] as Map<String, dynamic>);

    return SkeletonAnimation(skeletonData);
  }

  Future<List<String>> _appTextureFilesFromAtlas(String pathToAtlas) async {
    final r = <String>[];

    final data = await fm.loadString(pathToAtlas);
    if (data == null) {
      Fimber.e("Can't load atlas `$pathToAtlas`.");
      return r;
    }

    final reader = core.TextureAtlasReader(data);
    for (;;) {
      var line = reader.readLine();
      if (line == null) {
        break;
      }

      line = line.trim();
      if (line.isEmpty) {
        continue;
      }

      if (line.endsWith('.${C.allowedImageFileExtension}')) {
        r.add(line);
      }
    }

    return r;
  }
}
