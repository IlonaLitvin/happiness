import 'dart:async';
import 'dart:io' show File;
import 'dart:ui' as ui;

import 'package:fimber/fimber.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../app_file_managers.dart';
import '../cards/preview_card.dart';
import '../config.dart';
import 'welement.dart';

mixin LoadSpriteWelement on Welement {
  PreviewCard? previewCard;

  Future<Sprite?> loadSprite() async {
    previewCard ??= await PreviewCard.fromId(canvasName);
    if (previewCard == null) {
      Fimber.w('Not found a card by id `$canvasName`.');
      return null;
    }

    final pc = previewCard!;
    final fm = AppFileManagerLocalPriority();

    // sequence of paths for find sprite by analogy with load sounds
    final paths = <String>[
      if (stateName.isNotEmpty)
        pc.pathToSpriteInRootFolderState(bestScale, name, stateName),
      pc.pathToSpriteInRootFolderIdleState(bestScale, name),
      pc.pathToSpriteInRootFolder(bestScale, name),
      pc.pathToSpriteInRoot(bestScale, name),
    ];
    for (final path in paths) {
      if (C.debugSprite) {
        Fimber.i('Look at `$name` into the file `$path`...');
      }
      if (await fm.exists(path)) {
        final file = await fm.loadFile(path);
        if (file != null) {
          return _loadSpriteFromFile(file);
        }

        if (C.debugSprite) {
          Fimber.i('File `$path` exists, but not downloaded.');
        }
      }
      if (C.debugSprite) {
        Fimber.i("File `$path` doesn't exists.");
      }
    }

    Fimber.w('Not found a sprite `$name` with best scale $bestScale'
        ' for the ${pc.type.name} `$canvasName`.');

    return null;
  }

  Future<Sprite?> _loadSpriteFromFile(File file) async {
    final path = file.path;
    if (!file.existsSync()) {
      Fimber.e('File `$path` is not found.');
      return null;
    }

    // \thanks https://stackoverflow.com/a/66219110/963948
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      Fimber.e('Zero sized file `${file.path}`.');
      return null;
    }

    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    if (C.debugSprite) {
      Fimber.i('Loaded the sprite `$path`.');
    }

    return Sprite(image);
  }

  /// \thanks https://stackoverflow.com/a/65421705/963948
  Future<ui.Image> getImageByUrl(String path) async {
    final completer = Completer<dynamic>();
    final image = NetworkImage(path);
    image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    final imageInfo = await completer.future as ImageInfo;

    return imageInfo.image;
  }
}
