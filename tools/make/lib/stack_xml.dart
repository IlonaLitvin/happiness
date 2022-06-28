import 'dart:io' show File;

import 'package:vector_math/vector_math_64.dart';
import 'package:xml/xml.dart';

class StackXml {
  final File file;

  String get raw => file.readAsStringSync();

  XmlDocument get xml => XmlDocument.parse(raw);

  XmlElement get image => xml.findElements('image').single;

  List<XmlElement> get layers => image.findAllElements('layer').toList();

  StackXml(this.file) : assert(file.existsSync(), file.path);

  factory StackXml.path(String path) => StackXml(File(path));

  /// \warning Don't sort by keys for build a correct composition.
  Map<String, Vector2> get layerNamePositionMap {
    final r = <String, Vector2>{};

    for (final layer in layers) {
      final name = layer.getAttribute('name')!;
      final x = int.parse(layer.getAttribute('x')!).toDouble();
      final y = int.parse(layer.getAttribute('y')!).toDouble();
      r[name] = Vector2(x, y);
    }

    return r;
  }

  /// \warning Don't sort by keys for build a correct composition.
  Map<String, String> get layerSourceNameMap {
    final r = <String, String>{};

    for (final layer in layers) {
      final source = layer.getAttribute('src')!;
      final name = layer.getAttribute('name')!;
      r[source] = name;
    }

    return r;
  }

  Vector2 get size {
    final sw = image.getAttribute('w')!;
    final sh = image.getAttribute('h')!;

    return Vector2(int.parse(sw).toDouble(), int.parse(sh).toDouble());
  }
}
