import 'dart:ui' as ui;

import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flame_helpers/flutter_flame_helpers.dart';

import '../config.dart';
import 'load_sprite_welement.dart';
import 'opaque_sprite_welement.dart';
import 'render_sprite_welement.dart';
import 'welement.dart';

class SpriteWelement extends Welement
    with
        LoadSpriteWelement,
        RenderSpriteWelement,
        OpaqueSpriteWelement,
        HasPaint
    implements SpriteComponent {
  /// In seconds.
  static const defaultDurationBeforeEnd = 1.0;

  /// Time for FSM. Setup it in the `dataFileName` like `duration`.
  double durationBeforeEnd = defaultDurationBeforeEnd;

  SpriteWelement({
    required super.canvasName,
    required super.canvasSize,
    required super.bestScale,
    required super.welementSource,
    required super.screenSize,
    super.fsm,
    ui.Paint? overridePaint,
  }) {
    this.overridePaint = overridePaint;
  }

  @override
  void onMount() async {
    super.onMount();

    position
        .setFrom(welementSource.position.toVector2DependsOfSize(canvasSize));
    anchor = welementSource.anchor;
    init();
  }

  void init() async {
    sprite = await loadSprite();
    if (sprite == null) {
      Fimber.w("Can't load a sprite for `$canvasName`.");
      opaqueMap = null;
      return;
    }

    opaqueMap = await createOpaqueMap(sprite!, spriteName: name);

    size.setFrom(sprite!.srcSize * ownScaleWithBestScale);

    if (C.debugSprite) {
      Fimber.i('sprite for `$canvasName`'
          '\n\tstate $stateName'
          '\n\tposition $position'
          '\n\tsize $size'
          '\n\townScaleWithBestScale ${ownScaleWithBestScale.s2}'
          '\n\tduration $durationBeforeEnd');
    }
  }

  @mustCallSuper
  @override
  void onStateUpdated() {
    super.onStateUpdated();

    //init();
  }

  @override
  bool isOpaque(Vector2 pos) => isOpaquePixel(
        pos,
        scale: ownScaleWithBestScale,
        spriteName: name,
      );

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll(<String, dynamic>{
      'previewCard': previewCard,
    });
}
