import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/components.dart' hide ShapeComponent;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Draggable;
// ignore: depend_on_referenced_packages
import 'package:spine_flutter/spine_flutter.dart';

import '../cards/preview_card.dart';
import '../config.dart';
import '../picture_game.dart';
import '../welements/app_spine_render.dart';
import '../welements/welement_source.dart';

part 'animation_component.dart';

part 'game_component.dart';

part 'local_camera_game_component.dart';
