part of 'game_components.dart';

/// \todo Move Draggable to Welement. Why AnimationWelement can't catch it?
class AnimationComponent extends SpineComponent
    with Draggable, HasGameRef<PictureGame> {
  final String name;

  AnimationComponent({
    required PreviewCard previewCard,
    required this.name,
    required int bestScale,
    double? scale,
    super.size,
    String? startAnimation,
    bool? loop,
    BoxFit? fit,
    PlayState? playState,
  })  : assert(name.isNotEmpty),
        super(
          position: Vector2.zero(),
          scale: Vector2.all(scale ?? 1.0),
          spineRender: AppSpineRender(
            previewCard: previewCard,
            name: name,
            bestScale: bestScale,
            startAnimation: startAnimation,
            loop: loop,
            fit: fit,
            playState: playState,
          ),
        );

  Future<void>? init() async => onLoad();

  @override
  bool onDragStart(DragStartInfo info) {
    if (C.debugAnimation) {
      Fimber.i('Tap by ${info.eventPosition.global.s0} to animation `$name`'
          '\n\t${size.s0} ${position.s0} $anchor');
    }

    return true;
  }
}
