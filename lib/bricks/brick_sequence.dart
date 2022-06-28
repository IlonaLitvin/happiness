import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import 'brick.dart';
import 'brick_factory.dart';

/// \see ${C.assetsFolder}/later_cards/see_you_screen/about/about_*.json
/// \todo Rewrite all bricks with JsonSerializable.
class BrickSequence extends StatelessWidget {
  final List<Brick> list;

  const BrickSequence({super.key, required this.list});

  factory BrickSequence.fromJson(Map<String, dynamic> json) {
    final tagList = (json['list'] as List<dynamic>)
        .map((dynamic e) => e as String)
        .toList();

    final r = <Brick>[];
    for (final tag in tagList) {
      var hasBrick = false;
      final tagMap = json['map'] as Map<String, dynamic>;
      for (final entry in tagMap.entries) {
        if (entry.key == tag) {
          final data = entry.value as Map<String, dynamic>;
          Fimber.i('Building a brick `$tag` by data:\n$data');
          final brick = BrickFactory.fromJson(data);
          r.add(brick);
          Fimber.i('Brick `$tag` was created.');
          hasBrick = true;
          break;
        }
      }
      if (!hasBrick) {
        Fimber.w("Can't find a declaration for the brick `$tag`.");
      }
    }

    return BrickSequence(list: r);
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      );

  bool get isEmpty => list.isEmpty;
}
