import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'config.dart';
import 'game_components/game_components.dart';
import 'picture_source.dart';
import 'welements/sprite_welement.dart';

class PictureGame extends FlameGame
    with HasDraggables, HasKeyboardHandlerComponents {
  final PictureSource source;

  //Vector2 get screenSize => source.cardAware.screenSize().toVector2();
  final Vector2 screenSize;

  @override
  Vector2 get canvasSize => source.size;

  double get coverScale => scaleCoverSize(canvasSize, screenSize);

  /// In percents.
  int get bestScale => source.bestScale;

  /// \todo Remove [fitScale]?
  double get fitScale => scaleFitSize(canvasSize, screenSize);

  late final LocalCameraGameComponent localCameraGameComponent;

  PictureGame._create({required this.source})
      : screenSize = source.aware.screenSize() {
    debugMode = C.showSpriteBox;
  }

  factory PictureGame.fromPictureSource({
    required PictureSource source,
  }) =>
      PictureGame._create(source: source);

  @override
  Color backgroundColor() => Colors.black;

  @mustCallSuper
  @override
  Future<void>? onLoad() async {
    await _init();

    localCameraGameComponent = LocalCameraGameComponent(cardSize: canvasSize)
      ..cameraPosition = Vector2.zero()
      ..cameraZoom = coverScale;
    add(localCameraGameComponent);

    return super.onLoad();
  }

  Future<void> _init() async {
    //source.welementsSource.forEach((ws) async { - Don't do inner async forEach!
    for (final ws in source.welementSourceList) {
      if (!ws.isVisible) {
        continue;
      }

      if (C.debugPictureSource) {
        Fimber.i('Init `${ws.name}` by'
            ' position ${ws.position}'
            ' anchor ${ws.anchor}...');
      }

      final component = SpriteWelement(
        canvasName: source.name,
        welementSource: ws,
        screenSize: screenSize,
        canvasSize: canvasSize,
        bestScale: bestScale,
      );

      // \todo optimize Remove `await`?
      await add(component);
    }
  }
}
