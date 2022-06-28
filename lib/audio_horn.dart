import 'dart:io';

import 'package:audiofileplayer/audio_system.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';

import 'app_file_managers.dart';
import 'cards/preview_card.dart';
import 'config.dart';
import 'play_data.dart';

/// Based on https://pub.dev/packages/audiofileplayer
class AudioHorn {
  static const defaultVolume = 1.0;

  AudioHorn() {
    if (C.debugAudio) {
      Fimber.i('Init audio...');
    }

    AudioSystem.instance.addMediaEventListener(_listener);
  }

  final _audios = <Audio>[];

  Future<void> play(PlayData data) async {
    if (C.debugAudio) {
      Fimber.i('play() sound by data $data...');
    }

    final file = await _loadNextExistsOrFirstSoundFile(data);
    if (file == null) {
      Fimber.w('The sprite `${data.welementName}`'
          ' on the picture `${data.canvasName}` is not muted'
          ' but without sound for the state `${data.stateName}`.');
      return;
    }

    late final ByteData? bytes;
    try {
      if (file.existsSync()) {
        bytes = file.readAsBytesSync().buffer.asByteData();
      }
    } catch (ex) {
      Fimber.e('Error when read a file `$file`.', ex: ex);
      bytes = null;
    }

    if (bytes == null) {
      Fimber.w("Couldn't play a sound `$file`.");
      return;
    }

    final audio = Audio.loadFromByteData(
      bytes,
      onComplete: C.debugAudio
          ? () => Fimber.i('Sound `$file`'
              ' sized ${((bytes?.lengthInBytes ?? 0) / 1024).round()} KB'
              ' has finished and will dispose.')
          : null,
      onError: (error) => Fimber.e('Sound `$file` has error.', ex: error),
    )..play();
    // don't do it: after this the sounds are not stopped by `release()`
    //..dispose();

    _audios.add(audio);
  }

  void pause() async {
    for (final audio in _audios) {
      audio.pause();
    }
  }

  void resume() async {
    for (final audio in _audios) {
      audio.resume();
    }
  }

  void stop() async => release();

  void release() async {
    for (final audio in _audios) {
      audio
        ..pause()
        ..dispose();
    }
    _audios.clear();
  }

  // \todo final _nextSoundI = <String, int>{};

  Future<File?> _loadNextExistsOrFirstSoundFile(PlayData data) async {
    final previewCard = await PreviewCard.fromId(data.canvasName);
    if (previewCard == null) {
      Fimber.w('Not found a card by id `${data.canvasName}`.');
      return null;
    }

    final pc = previewCard;
    final fm = AppFileManagerLocalPriority();

    /// In percents.
    final bestScale = data.bestScale;

    const i = 1;
    /* \todo every sound file has a numeric suffix
    final key = pc.pathToSoundInRoot(bestScale, data.welementName, 0);
    _nextSoundI.putIfAbsent(key, () => 0);
    var i = _nextSoundI[key]! + 1;
    if (i > C.maxCountSounds) {
      i = 1;
    }
    _nextSoundI[key] = i;
    */

    // sequence of paths for find sound by analogy with load sprites
    final name = data.welementName;
    final stateName = data.stateName;
    final paths = <String>[
      if (stateName.isNotEmpty)
        pc.pathToSoundInRootFolderState(bestScale, name, stateName, i),
      pc.pathToSoundInRootFolderIdleState(bestScale, name, i),
      pc.pathToSoundInRootFolder(bestScale, name, i),
      pc.pathToSoundInRoot(bestScale, name, i),
    ];
    for (final path in paths) {
      if (C.debugAudio) {
        Fimber.i('Look at `$name` into the file `$path`...');
      }
      if (await fm.exists(path)) {
        final file = await fm.loadFile(path);
        if (file != null) {
          return file;
        }

        if (C.debugAudio) {
          Fimber.i('File `$path` exists, but not downloaded.');
        }
      }
      if (C.debugAudio) {
        Fimber.i("File `$path` doesn't exists.");
      }
    }

    Fimber.w('Not found a sound `$name` with best scale $bestScale'
        ' for the ${pc.type.name} `${pc.id}`.');

    return null;
  }

  /// Listener for transport control events from the OS.
  void _listener(MediaEvent mediaEvent) {
    if (C.debugAudio) {
      Fimber.i('App received media event of type `${mediaEvent.type}`.');
    }

    /* \todo
    final type = mediaEvent.type;
    if (type == MediaActionType.play) {
      resume();
      return;
    }

    if (type == MediaActionType.pause) {
      pause();
      return;
    }

    if (type == MediaActionType.stop) {
      stop();
      return;
    }
    */
  }
}
