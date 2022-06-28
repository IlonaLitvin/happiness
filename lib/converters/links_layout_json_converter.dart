// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../bricks/links_brick.dart';

class LinksLayoutJsonConverter implements JsonConverter<LinksLayout, String?> {
  static const defaultLinksLayout = LinksLayout.column;

  const LinksLayoutJsonConverter();

  @override
  LinksLayout fromJson(String? s) {
    assert(s == null || s.isLinksLayout, 's is `$s`');
    return s?.buildLinksLayout ?? defaultLinksLayout;
  }

  @override
  String toJson(LinksLayout o) => o.s;
}

extension LinksLayoutExtension on LinksLayout {
  String get s => toString();
}

extension LinksLayoutBuildStringExtension on String {
  LinksLayout? get buildLinksLayout {
    final s = 'LinksLayout.$this';
    for (final layout in LinksLayout.values) {
      final ls = layout.toString();
      if (ls == s) {
        return layout;
      }
    }

    return null;
  }

  bool get isLinksLayout => buildLinksLayout != null;
}
