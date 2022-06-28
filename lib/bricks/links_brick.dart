import 'package:flutter/material.dart';
import 'package:list_ext/list_ext.dart';

import '../converters/links_layout_json_converter.dart';
import 'brick.dart';
import 'link_brick.dart';

enum LinksLayout {
  undefined,
  column,
  row,
}

class LinksBrick extends Brick {
  final LinksLayout layout;
  final List<LinkBrick> list;

  const LinksBrick({
    super.key,
    required this.layout,
    required this.list,
  });

  factory LinksBrick.fromJson(Map<String, dynamic> json) => LinksBrick(
        layout:
            const LinksLayoutJsonConverter().fromJson(json['layout'] as String),
        list: (json['links'] as List<dynamic>)
            .map((dynamic e) => LinkBrick.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Widget build(BuildContext context) => Center(child: _buildWithLinksLayout());

  Widget _buildWithLinksLayout() {
    // ignore: unnecessary_cast
    final lw = list as List<Widget>;
    final children = lw.intersperse(const Divider(indent: 12)).toList();

    if (layout == LinksLayout.row) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
