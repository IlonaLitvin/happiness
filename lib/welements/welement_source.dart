/// TODO Move to `api_happiness`.
import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flame_helpers/flutter_flame_helpers.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../service_locator.dart';
import '../state_machine_data.dart';
import 'welement_order_counter.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'welement_source.g.dart';

@immutable
@JsonSerializable(includeIfNull: false, ignoreUnannotated: true)
class WelementSource {
  static const defaultPosition = '0 0';
  static const defaultAnchor = AnchorJsonConverter.defaultAnchor;

  /// Introduced it for easy management.
  static const defaultStateMachineData = StateMachineData(
    transitions: [
      WTransition('idle', WActions.onTap, 'idle'),
    ],
  );

  @JsonKey()
  final String name;

  @JsonKey(name: 'part_background')
  final bool isPartBackground;

  /// Like String because can define a coords depends a picture size.
  /// \see Test 'demo picture recovered from JSON data depends a picture size'.
  @JsonKey()
  final String position;

  @JsonKey()
  @AnchorJsonConverter()
  final Anchor anchor;

  @JsonKey()
  final StateMachineData sm;

  @JsonKey(name: 'visible')
  final bool isVisible;

  /// Play or not play a default sound by sprite name when sound effect
  /// is not placed.
  @JsonKey(name: 'mute')
  final bool isMute;

  /// We can make the welement bigger or smaller.
  @JsonKey()
  final double scale;

  bool get hasStateMachine => sm.transitionList.isNotEmpty;

  /// For catching the taps by welements.
  final int order;

  static int get _nextCount => sl.get<WelementOrderCounter>().next();

  WelementSource({
    required this.name,
    bool? isPartBackground,
    dynamic position,
    required this.anchor,
    StateMachineData? sm,
    bool? isVisible,
    bool? isMute,
    double? scale,
  })  : assert(name.isNotEmpty),
        assert(scale == null || scale > 0),
        isPartBackground = isPartBackground ?? false,
        position = _preparePosition(position),
        sm = sm ?? defaultStateMachineData,
        isVisible = isVisible ?? true,
        isMute = isMute ?? false,
        scale = scale ?? 1.0,
        order = _nextCount;

  factory WelementSource.fromString(
    String s, [
    Map<String, StateMachineData>? stateMachines,
  ]) =>
      WelementSource.fromJsonWithStateMachines(s.jsonMap, stateMachines);

  factory WelementSource.fromJsonWithStateMachines(
    Map<String, dynamic> json,
    Map<String, StateMachineData>? stateMachines,
  ) {
    /// `sm` can be a map with self-contained state machine or
    /// it can be a string with reference name to `stateMachines`
    if (stateMachines != null) {
      final dynamic smData = json['sm'];
      if (smData != null) {
        if (smData is String) {
          final sm = stateMachines[smData];
          if (sm != null) {
            json['sm'] = sm.toJson();
          } else {
            Fimber.w("Can't found state machine named `$smData`"
                ' among received names: ${stateMachines.keys}.'
                ' Welement `${json.sjson}` will start without state machine.');
            json['sm'] = null;
          }
        }
      }
    }

    return WelementSource.fromJson(json);
  }

  factory WelementSource.fromJson(Map<String, dynamic> json) =>
      _$WelementSourceFromJson(json);

  Map<String, dynamic> toJson() => _$WelementSourceToJson(this);

  @override
  String toString() => toJson().sjson;

  @override
  bool operator ==(Object other) =>
      (other is WelementSource) &&
      name == other.name &&
      // \todo we are interested the real position
      position.toVector2DependsOfSize(Vector2.zero()) ==
          other.position.toVector2DependsOfSize(Vector2.zero()) &&
      anchor.s == other.anchor.s;

  @override
  int get hashCode => toJson().hashCode;

  static String _preparePosition(dynamic pd) {
    if (pd is String) {
      final s = pd.trim();
      return s.isEmpty ? defaultPosition : s;
    }

    if (pd is List) {
      return '${pd[0]} ${pd[1]}';
    }

    if (pd is Vector2) {
      return '${pd[0]} ${pd[1]}';
    }

    return defaultPosition;
  }
}

class S extends WelementSource {
  S({
    required super.name,
    super.isPartBackground,
    super.position,
    Anchor? anchor,
    super.sm,
    super.isVisible,
    super.isMute,
    super.scale,
  }) : super(anchor: anchor ?? WelementSource.defaultAnchor);
}
