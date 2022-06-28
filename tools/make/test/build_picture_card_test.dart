import 'dart:io' show Directory, File;

import 'package:api_happiness/api_happiness.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:make/app_tools.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  const sourceFolder = 'source';
  const preparedFolder = 'prepared';

  const source = 'fox_and_fish';
  const sourcePath = 'test/data/$sourceFolder/$source';
  const destinationPath = 'test/data/$preparedFolder/$source';

  final tools = AppTools(sourcePath);

  test('AppTools buildPictureCard', () async {
    const scaledElements = <int>[
      100,
      //75,
      50,
      //25,
    ];

    await tools.buildPictureCard(destinationPath, scaledElements);

    expect(Directory(destinationPath).existsSync(), true);

    // about
    expect(Directory('$destinationPath/about').existsSync(), true);
    {
      final file = File('$destinationPath/about/about.json');
      expect(file.existsSync(), true);
      final json = file.readAsStringSync().jsonMap;
      final about = AboutCard.fromJson(json);
      expect(about.type, CardType.picture);
      expect(about.id, source);
      expect(about.originalSize, Vector2(4096, 4096));
      expect(about.compositions, ['1to1']);
      expect(about.elements, scaledElements);
      expect(about.previews, ['1to1/256x256/canvas']);

      // common + languages
      final files =
          await allFilesFromDirectory(Directory('$destinationPath/about'));
      expect(files.length, 4);
    }

    // compositions
    expect(Directory('$destinationPath/compositions').existsSync(), true);
    {
      expect(
          File('$destinationPath/compositions/1to1.json').existsSync(), true);

      final files = await allFilesFromDirectory(
          Directory('$destinationPath/compositions'));
      expect(files.length, 1);
    }

    // elements
    expect(Directory('$destinationPath/elements').existsSync(), true);
    {
      scaledElements.forEach((se) {
        expect(File('$destinationPath/elements/$se.exists').existsSync(), true);
        expect(File('$destinationPath/elements/$se.zip').existsSync(), true);
      });

      final files =
          await allFilesFromDirectory(Directory('$destinationPath/elements'));
      expect(files.length, 2 * scaledElements.length);
    }

    // previews
    expect(Directory('$destinationPath/previews').existsSync(), true);
    {
      expect(
          File('$destinationPath/previews/1to1/256x256/canvas.webp')
              .existsSync(),
          true);

      final files = await allFilesFromDirectory(
        Directory('$destinationPath/previews'),
        true,
      );
      expect(files.length, 1);
    }

    // other folders and files should be removed
    expect(Directory('$destinationPath/data').existsSync(), false);
    expect(Directory('$destinationPath/Thumbnails').existsSync(), false);
    expect(File('$destinationPath/mergedimage.png').existsSync(), false);
    expect(File('$destinationPath/mimetype').existsSync(), false);
    expect(File('$destinationPath/stack.xml').existsSync(), false);
    {
      final folders = await allFoldersFromDirectory(Directory(destinationPath));
      expect(folders.length, 4);

      final files = await allFilesFromDirectory(Directory(destinationPath));
      expect(files.length, 0);
    }

    // just a control check
    {
      const countFolders =
          // about
          1 +
              // compositions
              1 +
              // elements
              1 +
              // previews
              3;
      final folders = await allFoldersFromDirectory(
        Directory(destinationPath),
        true,
      );
      expect(folders.length, countFolders);

      final countFiles =
          // about
          4 +
              // compositions
              1 +
              // elements
              2 * scaledElements.length +
              // previews
              1;
      final files = await allFilesFromDirectory(
        Directory(destinationPath),
        true,
      );
      expect(files.length, countFiles);
    }
  });
}
