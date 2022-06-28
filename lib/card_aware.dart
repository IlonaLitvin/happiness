import 'dart:collection';

import 'package:dart_helpers/dart_helpers.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_helpers/flutter_helpers.dart';

import 'config.dart';

/// \see https://docs.flutter.dev/development/ui/assets-and-images#resolution-aware
/// \see https://en.wikipedia.org/wiki/Aspect_ratio_(image)
class CardAware {
  final BuildContext _context;

  const CardAware(this._context);

  Vector2 realScreenSize() => screenSize() * devicePixelRatio();

  /*
  Vector2 screenSize() => (screenOrientation().isLandscape &&
          MediaQuery.of(context).size.x >
              MediaQuery.of(context).size.y)
      ? MediaQuery.of(context).size.toVector2()
      : MediaQuery.of(context).size.toVector2().swapped;
  */
  //Vector2 screenSize() =>
  //    _isCorrectContext() ? MediaQuery.of(context).size.toVector2() : Vector2.zero();
  Vector2 screenSize() {
    if (!isCorrectContext(_context)) {
      return isTestEnvironment ? C.designSize : Vector2.zero();
    }

    final ss = MediaQuery.of(_context).size.toVector2();

    if (ss.x < ss.y && isScreenPortrait()) {
      return ss;
    }

    if (ss.x >= ss.y && isScreenLandscape()) {
      return ss;
    }

    if (ss.x < ss.y && isScreenLandscape()) {
      return ss.swapped;
    }

    return ss;
  }

  double devicePixelRatio() => isCorrectContext(_context)
      ? MediaQuery.of(_context).devicePixelRatio
      : 1.0;

  Orientation screenOrientation() => isCorrectContext(_context)
      ? MediaQuery.of(_context).orientation
      : Orientation.portrait;

  static Orientation orientation(Vector2 size) =>
      size.x > size.y ? Orientation.landscape : Orientation.portrait;

  bool isScreenLandscape() => screenOrientation().isLandscape;

  bool isScreenPortrait() => screenOrientation().isPortrait;

  static bool isLandscape(Vector2 size) => orientation(size).isLandscape;

  static bool isPortrait(Vector2 size) => orientation(size).isPortrait;

  Vector2 preferredScreenAspectSize() => preferredAspectSize(screenSize());

  SplayTreeMap<double, Vector2> preferredScreenAspectSizes() =>
      preferredAspectSizes(screenSize());

  // \see picture_aware_test.dart
  static Vector2 preferredAspectSize(Vector2 size) =>
      preferredAspectSizes(size).values.first;

  static SplayTreeMap<double, Vector2> preferredAspectSizes(Vector2 size) =>
      PreferredAspect(size).preferredAspectSizes();

  String preferredScreenSuffix() =>
      preferredScreenAspectSize().likeAspectSizeString;

  static String preferredSuffix(Vector2 aspectSize) =>
      aspectSize.likeAspectSizeString;

  /// First best available aspect size from prepared aspect sizes list.
  Vector2 bestAvailableAspectSize(List<Vector2> availableAspectSizes) {
    assert(availableAspectSizes.isNotEmpty);

    final aspectSizes = preferredScreenAspectSizes().values;
    for (final aspectSize in aspectSizes) {
      if (availableAspectSizes.contains(aspectSize)) {
        return aspectSize;
      }
    }

    return availableAspectSizes.first;
  }

  /// In percents.
  int bestScreenScale(Vector2 original, List<int> availableScales) =>
      bestScale(screenSize(), original, availableScales);

  /// In percents.
  static int bestScale(
    Vector2 screen,
    Vector2 original,
    List<int> availableScales,
  ) {
    assert(!screen.isNearZero);

    if (original.isNearZero || availableScales.isEmpty) {
      return 0;
    }

    var prevScale = availableScales.first;
    for (final scale in availableScales) {
      assert(scale > 0 && scale <= 100);
      assert(scale <= prevScale,
          'The available scales should be sorted in descending order.');
      final size = original * scale.toDouble() / 100;
      if (size.x < screen.x || size.y < screen.y) {
        return prevScale;
      }
      prevScale = scale;
    }

    return prevScale;
  }

  Vector2? realScreenBestSize(List<Vector2> spriteSizes) =>
      bestSize(realScreenSize(), spriteSizes);

  static Vector2? bestSize(Vector2 realScreenSize, List<Vector2> spriteSizes) {
    assert(!realScreenSize.isNearZero);

    if (spriteSizes.isEmpty) {
      return null;
    }

    final ss = List<Vector2>.from(spriteSizes);
    ss.sort((a, b) => a.x.compareTo(b.x));

    Vector2? r;
    for (final spriteSize in ss) {
      if (spriteSize.x < realScreenSize.x) {
        continue;
      }
      r = spriteSize;
      break;
    }

    if (r == null && ss.isNotEmpty) {
      r = ss.last;
    }

    return r;
  }

  /// \return 0 when `spriteSizes` doesn't contain `size`.
  static int resolutionDividerForSize(Vector2 size, List<Vector2> spriteSizes) {
    assert(!size.isNearZero || isTestEnvironment);

    if (spriteSizes.isNotEmpty) {
      final ss = List<Vector2>.from(spriteSizes);
      ss.sort((a, b) => b.x.compareTo(a.x));

      var divider = 1;
      for (final spriteSize in ss) {
        if (size == spriteSize) {
          return divider;
        }
        divider *= 2;
      }
    }

    return 0;
  }
}

// \see size_extension.dart
// \todo Nice group for this and size_extension.dart.
extension CardAwareAspectSizeOnSizeExtension on Vector2 {
  String get likeAspectSizeString =>
      '${x.round()}${C.aspectSizeDelimiter}${y.round()}';
}

extension CardAwareAspectSizeOnStringExtension on String {
  /// Works only with string represented from
  /// [CardAwareAspectSizeOnSizeExtension.likeAspectSizeString].
  /// \see PictureCheckerAspectSizeOnStringExtension.extractAspectSize
  Vector2 get likeAspectSize {
    final s = trim();
    if (s.isEmpty) {
      return Vector2.zero();
    }

    final l = s.split(C.aspectSizeDelimiter);
    assert(
        l.length == 2,
        'String should be contains the numeric values separated the'
        ' C.aspectSizeDelimiter = `${C.aspectSizeDelimiter}`.'
        ' Has: `$l`');

    if (l.length != 2) {
      return Vector2.zero();
    }

    final sx = l[0];
    final x = int.tryParse(sx);
    assert(x != null, "Can't parse X from `$sx`");

    final sy = l[1];
    final y = int.tryParse(sy);
    assert(y != null, "Can't parse Y from `$sy`");

    return Vector2(x?.toDouble() ?? 0, y?.toDouble() ?? 0);
  }
}
