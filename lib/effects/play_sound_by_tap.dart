import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../audio_horn.dart';
import '../effects/weffect.dart';
import '../play_data.dart';
import '../service_locator.dart';
import '../welements/welement.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'play_sound_by_tap.g.dart';

/// Play the sound for welement by tap.
@JsonSerializable(includeIfNull: false)
class PlaySoundByTap extends WEffect {
  AudioHorn get audio => sl.get<AudioHorn>();

  final double volume;

  const PlaySoundByTap({
    this.volume = 1.0,
  })  : assert(volume >= 0),
        super(name: 'PlaySoundByTap');

  @override
  @mustCallSuper
  void run(Welement we) {
    super.run(we);

    final playData = PlayData(
      canvasName: we.canvasName,
      bestScale: we.bestScale,
      welementName: we.name,
      stateName: we.stateName,
      volume: volume,
    );
    audio.play(playData);
  }

  factory PlaySoundByTap.fromJson(Map<String, dynamic> json) =>
      _$PlaySoundByTapFromJson(json);

  @mustCallSuper
  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$PlaySoundByTapToJson(this));

  @override
  String toString() {
    return '${objectRuntimeType(this, name)}'
        '(volume: $volume)';
  }
}
