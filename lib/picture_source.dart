/// TODO Move to `api_happiness`.
import 'dart:io' show File;

import 'package:api_happiness/api_happiness.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_flame_helpers/flutter_flame_helpers.dart';
import 'package:flutter_helpers/flutter_helpers.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import 'card_aware.dart';
import 'cards/preview_card.dart';
import 'config.dart';
import 'extensions/card_aware_json_extension.dart';
import 'picture_path_data.dart';
import 'state_machine_data.dart';
import 'welements/welement_source.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
// \todo part 'picture_source.g.dart';

/// [PictureSource] = composition JSON file + calculated data.
/// \todo Can we rename class [PictureSource] to `Composition`?
/// \todo @JsonSerializable(ignoreUnannotated: true, includeIfNull: false)
@immutable
class PictureSource {
  @JsonKey()
  final CardType type;

  @JsonKey(name: 'aspect_size')
  @Vector2IntJsonConverter()
  final Vector2 aspectSize;

  @JsonKey()
  final String name;

  String get id => name;

  @JsonKey()
  @Vector2JsonConverter()
  final Vector2 size;

  /// In percents.
  final int bestScale;

  final CardAware aware;

  @JsonKey(name: 'state_machines')
  final Map<String, StateMachineData> stateMachines;

  final List<WelementSource> welementSourceList;

  List<WelementSource> get ws => welementSourceList;

  Orientation get orientation => CardAware.orientation(size);

  bool get isLandscape => orientation.isLandscape;

  bool get isPortrait => orientation.isPortrait;

  PictureSource({
    required this.aspectSize,
    required this.name,
    required this.size,
    required this.stateMachines,
    required this.bestScale,
    required this.aware,
    List<WelementSource>? ws,
  })  : assert(name.isNotEmpty),
        assert(size.x > 0 && size.y > 0, 'The picture size should be natural.'),
        type = CardType.picture,
        welementSourceList = ws ?? [];

  static Future<PictureSource?> fromPreviewCard(
    PreviewCard previewCard,
    CardAware aware,
  ) async {
    if (C.debugPictureSource) {
      Fimber.i('build picture source by `$previewCard`');
    }
    final pathData = PicturePathData(previewCard.id, aware);
    final json = await pathData.dataComposition(previewCard.about.compositions);
    if (C.debugCardChecker) {
      Fimber.i('for picture `${previewCard.id}`'
          ' found json composition: `$json`');
    }

    final bestScale = previewCard.bestScale(aware);

    return json.isEmpty ? null : fromJson(json, aware, bestScale);
  }

  // \see Test 'demo picture recovered from not full JSON data'.
  static Future<PictureSource> fromFile(
    String path,
    CardAware aware,
    int resolutionDivider,
  ) async {
    assert(path.isNotEmpty);
    assert(resolutionDivider > 0);

    if (C.debugPictureSource) {
      Fimber.i('build picture source from file `$path`');
    }

    return PictureSource.fromString(
      File(path).readAsStringSync(),
      aware,
      resolutionDivider,
    );
  }

  static Future<PictureSource> fromString(
    String s,
    CardAware aware,
    int resolutionDivider,
  ) async {
    assert(s.isNotEmpty);
    assert(resolutionDivider > 0);

    if (C.debugPictureSource) {
      Fimber.i('build picture source from string\n`$s`');
    }

    return PictureSource.fromJson(s.jsonMap, aware, resolutionDivider);
  }

  static Future<PictureSource> fromJson(
    Map<String, dynamic> json,
    CardAware aware,
    int bestScale,
  ) async {
    if (C.debugPictureSource) {
      Fimber.i('build picture source from JSON:\n$json');
    }

    // \warning `aspectSize` should be same suffix in composition file name
    final aspectSize = (json['aspect_size'] as String).likeAspectSize;

    // \warning `name` should be same picture folder name
    final name = (json['name'] as String).trim();

    final size = _prepareSize(json['size']);

    final stateMachinesSource =
        (json['state_machines'] ?? <String, dynamic>{}) as Map<String, dynamic>;
    final stateMachines =
        stateMachinesSource.map((key, dynamic value) => MapEntry(
              key,
              StateMachineData.fromJson(value as Map<String, dynamic>),
            ));

    final wsl = (json['ws'] ?? <dynamic>[]) as List<dynamic>;
    final ws = wsl
        .map((dynamic s) => WelementSource.fromJsonWithStateMachines(
            s as Map<String, dynamic>, stateMachines))
        .toList();

    return PictureSource(
      aspectSize: aspectSize,
      name: name,
      size: size,
      stateMachines: stateMachines,
      bestScale: bestScale,
      aware: aware,
      ws: ws,
    );
  }

  static Vector2 _prepareSize(dynamic d) {
    if (d is String) {
      return d.toVector2DependsOfSize(Vector2.zero());
    }

    final sizeAsList = (d ?? <dynamic>[]) as List<dynamic>;
    if (sizeAsList.length != 2) {
      Fimber.w('The picture size should be defined in the JSON.');
    }

    return (sizeAsList.length == 2)
        ? Vector2((sizeAsList[0] as num).toDouble(),
            (sizeAsList[1] as num).toDouble())
        : Vector2.zero();
  }

  Map<String, dynamic> toJson() {
    final r = <String, dynamic>{
      'aspect_size': aspectSize.likeAspectSizeString,
      'name': name,
      'size': size.json,
      'cardAware': aware.json,
    };

    if (stateMachines.isNotEmpty) {
      r['state_machines'] =
          stateMachines.map((key, value) => MapEntry(key, value.toJson()));
    }

    if (welementSourceList.isNotEmpty) {
      r['ws'] = welementSourceList.map((e) => e.toJson()).toList();
    }

    return r;
  }

  @override
  String toString() => toJson().sjson;

  @override
  bool operator ==(Object other) =>
      (other is PictureSource) &&
      name == other.name &&
      listEquals(welementSourceList, other.welementSourceList);

  @override
  int get hashCode => toJson().hashCode;
}
