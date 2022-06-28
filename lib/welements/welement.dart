import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flame_helpers/flutter_flame_helpers.dart';

import '../config.dart';
import '../effects/play_sound_by_tap.dart';
import '../fsm.dart';
import '../picture_game.dart';
import '../state_machine_data.dart';
import 'welement_source.dart';

abstract class Welement extends PositionComponent
    with Draggable, HasGameRef<PictureGame> {
  final String canvasName;

  final Vector2 canvasSize;

  double get ownScale => welementSource.scale;

  double get ownScaleWithBestScale => ownScale * (100 / bestScale);

  double localScale = 1.0;

  /// \TODO Remove [globalScale].
  static const globalScale = 1.0;

  /// Scale in percent.
  /// 100 = 1.0, 75 = 0.75, ...
  final int bestScale;

  final WelementSource welementSource;

  final Vector2 screenSize;

  Rect get screenRect => screenSize.toRect();

  @override
  Vector2 get scaledSize => size * globalScale * localScale;

  Vector2 get unscaledSize => size / globalScale / localScale;

  String get name => welementSource.name;

  int get order => priority;

  bool get isPartBackground => welementSource.isPartBackground;

  bool get isVisible => _isVisibleOverride ?? welementSource.isVisible;

  bool? _isVisibleOverride;

  set isVisible(bool v) => _isVisibleOverride = v;

  bool get isMute => welementSource.isMute;

  /// Finite state machine for animations, effects, etc.
  /// \see sendActionFsm()
  FSM? fsm;

  String get stateName => fsm?.stateName ?? '';

  /// We can't transfer the gestures to effects through WAction
  /// therefore save them in the welement itself.
  /// \todo Can we remove it now?
  TapDownInfo? lastTapDownDetails;

  final void Function(bool ok)? onAfterInitHandler;

  Welement({
    required this.canvasName,
    required this.canvasSize,
    required this.bestScale,
    required this.welementSource,
    required this.screenSize,
    this.fsm,
    this.onAfterInitHandler,
  })  : assert(canvasName.isNotEmpty),
        assert(screenSize.length2 > 0),
        assert(canvasSize.length2 > 0),
        assert(bestScale > 0 && bestScale <= 100),
        super(priority: welementSource.order) {
    if (fsm == null && welementSource.hasStateMachine) {
      _buildFsmFromSource();
    }
  }

  void _buildFsmFromSource() {
    if (C.debugFsm) {
      Fimber.i('Init the finite state machine for `$name`');
    }

    fsm = FSM();

    // start state will be the first state from the `stateList`
    //final startState = fsm!.newStartState;
    for (final state in welementSource.sm.transitionList) {
      if (C.debugFsm) {
        Fimber.i(
            'Add transition ${state.from} -> ${state.action} -> ${state.to}');
      }
      fsm!.addTransition(state.from, state.action, state.to);
    }
    //final stopState = fsm!.newStopState;

    for (final director in welementSource.sm.directorList) {
      fsm!.addCallbacks(
        director.stateName,
        onEntry: () => director.runAll(this),
      );
    }

    fsm!.start();
  }

  @mustCallSuper
  void onAfterInit(bool ok) {
    if (onAfterInitHandler != null) {
      final fn = onAfterInitHandler!;
      fn(ok);
    }
  }

  @override
  bool containsPoint(Vector2 point) {
    return super.containsPoint(point / globalScale);
  }

  bool sendActionFsm(WAction action) {
    if (fsm == null) {
      Fimber.w('Attempt send action $action but `$name` without FSM.');
      return false;
    }

    final prevState = fsm!.current;
    fsm!.sendAction(action);
    if (prevState != fsm!.current) {
      onStateUpdated();
      return true;
    }

    return false;
  }

  @mustCallSuper
  void onStateUpdated() {
    if (C.debugFsm) {
      Fimber.i('FSM state for `$name` updated to `$stateName`');
    }
  }

  Vector2? _dragStartPosition;
  double _dragDistance = 0.0;

  static Welement? _dragCameraCatcher;

  @override
  bool onDragStart(DragStartInfo info) {
    _dragStartPosition = info.eventPosition.game;
    _dragDistance = 0;
    _dragCameraCatcher = this;

    return true;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (_dragStartPosition == null) {
      return false;
    }

    const maxDelta = 4.0;
    var delta = info.delta.game;
    if (delta.length2 > maxDelta * maxDelta) {
      delta = delta.normalized() * maxDelta;
    }
    if (_dragCameraCatcher == this) {
      gameRef.localCameraGameComponent.move(-delta);
    }

    _dragDistance += delta.length;

    return true;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    var detected = true;

    const detectDragMoveDistance = 24.0;
    if (_dragStartPosition != null && _dragDistance < detectDragMoveDistance) {
      final pos = _dragStartPosition! / Welement.globalScale -
          toRect().topLeft.toVector2();

      if (isOpaque(pos)) {
        runEffects(const OnTapAction());
        detected = false;
      }
    }

    onDragCancel();

    return detected;
  }

  @override
  bool onDragCancel() {
    _dragStartPosition = null;
    _dragDistance = 0;
    _dragCameraCatcher = null;

    return true;
  }

  bool isOpaque(Vector2 pos) => true;

  void runEffects(WAction action) {
    if (C.debugEffect) {
      Fimber.i('Run effects for `$name` before send action to FSM.');
    }

    final isSent = sendActionFsm(action);
    if (!isSent) {
      // attempt play a default sound for this entity
      if (isMute) {
        if (C.debugAudio) {
          Fimber.i('Element `$this` is muted in source.');
        }
      } else {
        const PlaySoundByTap().run(this);
      }
    }
  }

  /// \TODO Move to Utils. Really need this for [PictureGame]?
  /// How part of element we will see at the screen.
  /// In percents, [0; 100].
  int viewedPercent() {
    if (C.alwaysShowWholePicture) {
      return 100;
    }

    if (!isVisible) {
      return 0;
    }

    final weRect = toRect();
    final intersectRect = weRect.intersect(screenRect);

    final isOverlapped = intersectRect.width > 0 && intersectRect.height > 0;
    if (!isOverlapped) {
      return 0;
    }

    final overlappedSquare = intersectRect.width * intersectRect.height;
    final square = weRect.width * weRect.height;

    return (overlappedSquare / square * 100).round();
  }

  Map<String, dynamic> toJson() {
    final r = <String, dynamic>{
      'canvas name': canvasName,
      'name': name,
      'canvas size': canvasSize.toJson1(),
      'order': order,
      'position': position.toJson1(),
      'anchor': anchor.s,
      'size': size.toJson1(),
      'local scale': localScale.n1,
      'global scale': globalScale.n1,
      'best scale': bestScale,
      'screen size': screenSize.toJson1(),
      'fsm': fsm.toString(),
    };
    if (isPartBackground == true) {
      r.addAll(<String, dynamic>{
        'is part background': isPartBackground,
      });
    }
    if (isVisible == false) {
      r.addAll(<String, dynamic>{
        'is visible': isVisible,
      });
    }
    if (isMute == true) {
      r.addAll(<String, dynamic>{
        'is mute': isMute,
      });
    }
    return r;
  }

  @override
  String toString() => toJson().sjson;
}
