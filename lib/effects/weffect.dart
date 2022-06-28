import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_helpers/flutter_helpers.dart';

import '../config.dart';
import '../welements/welement.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
//part 'weffect.g.dart';

/// \warning All children should be call onComplete() when completed.
/// \warning We should extend `WEffectExtension` after added effect.
/// \todo Extend with `Equatable`.
@immutable
abstract class WEffect {
  /// \TODO With final keyword we lost the `name` when serialize to JSON.
  /// See weffect_test/JsonSerializable.
  /// But without final picture_source_test/JsonSerializable is red.
  final String name;

  /// in seconds
  final double duration;

  /// \see Click Ctrl+`Curve` or look at https://youtu.be/qnnlGcZ8vaQ for build an own curve.
  @CurveJsonConverter()
  final Curve curve;

  const WEffect({
    required this.name,
    this.duration = 1.0,
    this.curve = CurveJsonConverter.defaultCurve,
  })  : assert(name.length > 0),
        assert(duration >= 0);

  @mustCallSuper
  void run(Welement we) {
    //we.clearEffects();

    if (C.debugEffect) {
      Fimber.i('Run effect for `${we.name}`:\n$this');
    }
  }

  @mustCallSuper
  // \see TODO for field `name`.
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name};

  @override
  String toString() => toJson().sjson;

  @override
  bool operator ==(Object other) => (other is WEffect) && name == other.name;

  @override
  int get hashCode => toJson().hashCode;
}
