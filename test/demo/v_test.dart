import 'package:dart_helpers/dart_helpers.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/demo/v.dart';

void main() {
  test('JsonSerializable', () {
    final v = V(name: 'Demo V', position: Vector2(0.1, 23));
    final vString = v.sjson;
    final vRecovered = V.fromString(vString);

    expect(v.name, vRecovered.name, reason: '$v');
    expect(v.position, vRecovered.position, reason: '$v');
    expect(vString, vRecovered.sjson);
  });
}
