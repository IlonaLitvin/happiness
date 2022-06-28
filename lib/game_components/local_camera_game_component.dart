part of 'game_components.dart';

class LocalCameraGameComponent extends Component
    with KeyboardHandler, HasGameRef<PictureGame>
    implements GameComponent {
  static const startZoom = 1.0;
  static const startZoomVelocity = 0.0;
  static const deltaZoomWhenPressKey = 0.3;
  static const kDampingZoomVelocity = 1 / 1.05;
  static const multiplierZoomVelocity = 1.0;
  static const lowerScale = 0.1;
  static const upperScale = 1.0;

  static const kDampingMoveVelocity = 1 / 1.2;
  static const multiplierMoveVelocity = 10.0;

  final Vector2 cardSize;

  Vector2 cameraPosition;
  Vector2 cameraMoveVelocity;

  double cameraZoom;
  double cameraZoomVelocity;

  Camera get camera => gameRef.camera;

  Rect get bounds => camera.worldBounds!;

  Vector2 get gameSize => camera.gameSize;

  LocalCameraGameComponent({required this.cardSize})
      : assert(cardSize.x > 0 && cardSize.y > 0),
        cameraPosition = Vector2.zero(),
        cameraMoveVelocity = Vector2.zero(),
        cameraZoom = startZoom,
        cameraZoomVelocity = startZoomVelocity;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    camera.snapTo(cameraPosition);
    camera.setRelativeOffset(WelementSource.defaultAnchor);
    camera.zoom = cameraZoom;

    camera.worldBounds = Rect.fromLTWH(0, 0, cardSize.x, cardSize.y);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!cameraMoveVelocity.isNearZero) {
      final moveAccelerate = cameraMoveVelocity * dt;
      cameraPosition = _addMove(cameraPosition, moveAccelerate);
      camera.snapTo(cameraPosition);
      cameraMoveVelocity *= kDampingMoveVelocity;
    }

    if (cameraZoomVelocity.abs() > Vector2Vector2Extension.zeroLength) {
      final zoomAccelerate = cameraZoomVelocity * dt;
      cameraZoom = (cameraZoom + zoomAccelerate).clamp(lowerScale, upperScale);
      camera.zoom = cameraZoom;
      cameraZoomVelocity *= kDampingZoomVelocity;
    }
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    //Fimber.i('Pressed key $keysPressed');

    // num -
    if (keysPressed.contains(LogicalKeyboardKey.minus)) {
      cameraZoomVelocity -= deltaZoomWhenPressKey;
      return true;
    }

    // num +
    if (keysPressed.contains(LogicalKeyboardKey.equal)) {
      cameraZoomVelocity += deltaZoomWhenPressKey;
      return true;
    }

    return false;
  }

  void move(Vector2 d) => cameraMoveVelocity += d * multiplierMoveVelocity;

  void zoom(double d) => cameraZoomVelocity += d * multiplierZoomVelocity;

  Vector2 _addMove(Vector2 position, Vector2 delta) {
    final p = position + delta;
    if (bounds.width > gameSize.x * camera.zoom) {
      final cameraLeftEdge = position.x;
      final cameraRightEdge = position.x + gameSize.x;
      if (cameraLeftEdge < bounds.left) {
        p.x = bounds.left;
      } else if (cameraRightEdge > bounds.right) {
        p.x = bounds.right - gameSize.x;
      }
    }

    if (bounds.height > gameSize.y * camera.zoom) {
      final cameraTopEdge = position.y;
      final cameraBottomEdge = position.y + gameSize.y;
      if (cameraTopEdge < bounds.top) {
        p.y = bounds.top;
      } else if (cameraBottomEdge > bounds.bottom) {
        p.y = bounds.bottom - gameSize.y;
      }
    }

    return p;
  }
}
