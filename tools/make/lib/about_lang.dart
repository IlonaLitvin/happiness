import 'dart:async';
import 'dart:io' show Directory, File;

import 'package:dart_helpers/dart_helpers.dart';
import 'package:path/path.dart' as p;

class AboutLang {
  final Directory path;

  AboutLang(this.path) : assert(path.existsSync(), path.path);

  factory AboutLang.path(String path) => AboutLang(Directory(path));

  Future<Map<String, File>> get files async {
    final r = <String, File>{};

    final files = await allFilesFromDirectory(path);
    for (final file in files) {
      final lang = p.basenameWithoutExtension(file.path);
      r[lang] = file as File;
    }

    return r;
  }
}
