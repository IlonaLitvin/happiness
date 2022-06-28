import 'dart:io' show Directory, File;

import 'package:make/app_tools.dart';
import 'package:test/test.dart';

void main() {
  const sourceFolder = 'source';
  const preparedFolder = 'prepared';

  const source = 'fox_and_fish';
  const sourcePath = 'test/data/$sourceFolder/$source';
  const destinationPath = 'test/data/$preparedFolder/$source';

  final tools = AppTools(sourcePath);

  test('AppTools extractFromOra', () async {
    await tools.extractFromOra(destinationPath);

    expect(Directory(destinationPath).existsSync(), true);
    expect(Directory('$destinationPath/data').existsSync(), true);
    expect(File('$destinationPath/Thumbnails/thumbnail.png').existsSync(), true);
    expect(File('$destinationPath/mergedimage.png').existsSync(), true);
    expect(File('$destinationPath/stack.xml').existsSync(), true);
  });
}
