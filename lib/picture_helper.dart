import 'package:flame/extensions.dart';

class PictureHelper {
  final int width;
  final int height;

  /// The original size of picture in pixels.
  Vector2 get size => Vector2(width.toDouble(), height.toDouble());

  Vector2 get topLeft => rect.topLeft.toVector2();

  Vector2 get topCenter => rect.topCenter.toVector2();

  Vector2 get topRight => rect.topRight.toVector2();

  Vector2 get centerLeft => rect.centerLeft.toVector2();

  Vector2 get center => rect.center.toVector2();

  Vector2 get centerRight => rect.centerRight.toVector2();

  Vector2 get bottomLeft => rect.bottomLeft.toVector2();

  Vector2 get bottomCenter => rect.bottomCenter.toVector2();

  Vector2 get bottomRight => rect.bottomRight.toVector2();

  double get uppermost => 0.0;

  double get rightmost => width.toDouble();

  double get lowermost => height.toDouble();

  double get leftmost => 0.0;

  const PictureHelper(this.width, this.height)
      : assert(width > 0),
        assert(height > 0);

  PictureHelper.fromVector2(Vector2 size)
      : assert(size.x > 0),
        assert(size.y > 0),
        width = size.x.round(),
        height = size.y.round();

  /// The rectangle for handy inner calculation.
  Rect get rect => Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
}
