import 'dart:ui' as ui;

import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/components.dart';

import '../config.dart';
import 'welement.dart';

// ignore: comment_references
/// \see [SpriteTransparentExtension]
mixin OpaqueSpriteWelement on Welement {
  OpaqueMap? opaqueMap;

  /// \see [isOpaquePixel]
  /// \param lowLimitColorAlpha Define tapping when a transparent into a sprite above this value.
  Future<OpaqueMap?> createOpaqueMap(
    Sprite sprite, {
    int lowLimitColorAlpha = 0x30,
    String spriteName = '',
  }) async {
    final bytes =
        await sprite.image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bytes == null) {
      Fimber.w("Can't transform image to byte data.");
      return null;
    }

    var countOpaquePixels = 0;

    final width = sprite.srcSize.x.round();
    final height = sprite.srcSize.y.round();
    final countPixels = width * height;
    // \todo optimize Store a half or even a quarter of sprite.
    final map = List<bool>.generate(countPixels, (i) => false, growable: false);
    for (var offset = 0, i = 0; offset < 4 * countPixels; offset += 4, ++i) {
      final alpha = bytes.colorIntAtByteOffset(offset).colorIntAlpha;
      final isOpaque = alpha > lowLimitColorAlpha;
      map[i] = isOpaque;
      if (isOpaque) {
        ++countOpaquePixels;
      }
    }

    if (C.debugSprite) {
      final opaquePercent = (countOpaquePixels / countPixels * 100).round();
      Fimber.i('Opaque for sprite `$spriteName`'
          ' is ~$opaquePercent% $countOpaquePixels / $countPixels pixels'
          ' with lowLimitColorAlpha $lowLimitColorAlpha');
    }

    return OpaqueMap(width: width, height: height, map: map);
  }

  /// \warning Call [createOpaqueMap] before use this method.
  bool isOpaquePixel(
    Vector2 pos, {
    double scale = 1.0,
    String spriteName = '',
  }) {
    assert(opaqueMap != null, 'Call createOpaqueMap() before this method.');
    assert(scale > 0);

    if (opaqueMap == null) {
      return false;
    }

    final scaledX = (pos.x / scale).round();
    final scaledY = (pos.y / scale).round();
    final w = opaqueMap!.width;
    final h = opaqueMap!.height;
    final offset = scaledX + (scaledY * w);
    if (offset >= w * h || offset < 0) {
      Fimber.w('$pos are out of range for sprite `$spriteName` ${w}x$h');
      return false;
    }

    final isOpaque = opaqueMap!.map[offset];
    if (C.debugSprite) {
      Fimber.i('Opaque for sprite `$spriteName` is $isOpaque, pos ${pos.s0}');
    }

    return isOpaque;
  }
}

class OpaqueMap {
  final int width;
  final int height;
  final List<bool> map;

  const OpaqueMap({
    required this.width,
    required this.height,
    required this.map,
  })  : assert(width > 0),
        assert(height > 0),
        assert(map.length > 0);
}
