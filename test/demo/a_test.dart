import 'package:dart_helpers/dart_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/demo/a.dart';

void main() {
  test('JsonSerializable', () {
    final a = A(name: 'Demo A');
    final aString = a.sjson;
    final aRecovered = A.fromString(aString);

    expect(a.name, aRecovered.name, reason: '$a');
    expect(aString, aRecovered.sjson);
  });

  test('JsonLiteral', () {
    expect(glossary, hasLength(1));
  });
}
