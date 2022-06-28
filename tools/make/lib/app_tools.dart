import 'dart:io' show Directory, File, FileSystemException;

import 'package:archive/archive_io.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:image/image.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:vector_math/vector_math_64.dart';

import 'about_lang.dart';
import 'stack_xml.dart';

class AppTools {
  final Directory source;

  late Directory current;

  String get sourceFolder => path.basename(source.path);

  String get sourcePath => source.path;

  String get currentFolder => path.basename(current.path);

  String get currentPath => current.path;

  late final StackXml stack;
  late final Vector2 size;
  late final Vector2 aspectSize;
  late final Vector2 previewSize;

  AppTools(String currentPath)
      : assert(currentPath.isNotEmpty),
        source = Directory(currentPath) {
    assert(source.existsSync());
    current = source;
  }

  Future<void> buildPictureCard(
    String destinationPath,
    List<int> scaledElements,
  ) async {
    assert(destinationPath.isNotEmpty);

    print('\n--build_picture_card'
        '\n\tsource: `$sourcePath`'
        '\n\tdestinationPath: `$destinationPath`'
        '\n');

    final destination = Directory(destinationPath);

    // 1) Clear destination path.
    var step = 1;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Clearing destination path'
          ' `${destination.path}`...');
      if (destination.existsSync()) {
        destination.deleteSync(recursive: true);
      }
      print('$currentIndent\tSuccess clear destination path'
          ' `${destination.path}`.');
    }

    // 2) Extract files from `*.ora`.
    ++step;
    resetCurrentIndent();
    const state = 'idle';
    final destinationOra = Directory('${destination.path}/sprites/$state');
    {
      // TODO Recognize other states also.
      final pathToFile =
          File('${current.path}/sprites/$state/$sourceFolder.ora');
      print('$currentIndent$step) Extracting files from `${pathToFile.path}`'
          ' to `${destinationOra.path}`...');
      increaseCurrentIndent();
      final countFiles = _extractFromOra(pathToFile, destinationOra);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess extract $countFiles files'
          ' from `${pathToFile.path}` to `${destinationOra.path}`.');
    }

    // 3) Build `about.json`: common file.
    ++step;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Building `about.json`...');
      increaseCurrentIndent();
      await _buildAboutCommonJson(destinationOra, destination, scaledElements);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess build `about.json`.');
    }

    // 4) Build `about_xx.json`: languages files.
    ++step;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Building `about_xx.json`: all languages...');
      increaseCurrentIndent();
      await _buildAboutAllLanguagesJson(destination);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess build `about_xx.json`: all languages.');
    }

    // 5) Build previews.
    ++step;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Building previews...');
      increaseCurrentIndent();
      await _buildPreviews(destinationOra, destination);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess build previews.');
    }

    // 6) Build elements.
    ++step;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Building elements...');
      increaseCurrentIndent();
      await _buildElements(destinationOra, state, destination, scaledElements);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess build elements.');
    }

    // 7) Build composition.
    ++step;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Building composition...');
      increaseCurrentIndent();
      await _buildComposition(destination);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess build composition.');
    }

    // 8) Remove unused folders and files.
    ++step;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Removing unused folders and files...');
      increaseCurrentIndent();
      await _removeUnusedFoldersAndFiles(destination, scaledElements);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess remove unused folders and files.');
    }
  }

  Future<void> extractFromOra(String destinationPath) async {
    assert(destinationPath.isNotEmpty);

    print('\n--extract_from_ora'
        '\n\tsource: `$sourcePath`'
        '\n\tdestinationPath: `$destinationPath`'
        '\n');

    final destination = Directory(destinationPath);

    // 1) Clear destination path.
    var step = 1;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Clearing destination path'
          ' `${destination.path}`...');
      if (destination.existsSync()) {
        destination.deleteSync(recursive: true);
      }
      print('$currentIndent\tSuccess clear destination path'
          ' `${destination.path}`.');
    }

    // 2) Extract files from `*.ora`.
    ++step;
    resetCurrentIndent();
    {
      // TODO Recognize other states also.
      const state = 'idle';
      final pathToFile =
          File('${current.path}/sprites/$state/$sourceFolder.ora');
      print('$currentIndent$step) Extracting sprites'
          ' from `${pathToFile.path}` to `${destination.path}`...');
      if (!pathToFile.existsSync()) {
        throw FileSystemException("File `${pathToFile.path}` doesn't exists.");
      }

      increaseCurrentIndent();
      final countFiles = _extractFromOra(pathToFile, destination);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess extract $countFiles files'
          ' from `${pathToFile.path}` to `${destination.path}`.');
    }
  }

  int _extractFromOra(File source, Directory destination) {
    destination.createSync(recursive: true);

    final bytes = source.readAsBytesSync();
    print('${currentIndent}Size of ${source.path}: ${bytes.length} bytes.');
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      print('$currentIndent\tFile `$file`');
      final out = path.join(destination.path, file.name);
      if (file.isFile) {
        //print('$currentIndent\t\tGetting content from'
        //    ' `${file.name}` to `$out`...');
        final os = OutputFileStream(out);
        file.writeContent(os);
        os.close();
      } else {
        //print('$currentIndent\t\tCreating directory `$out`...');
        Directory(out).createSync(recursive: true);
        //print('$currentIndent\t\tSuccess create directory `$out`.');
      }
    }

    return archive.length;
  }

  Future<void> _buildAboutCommonJson(
    Directory destinationOra,
    Directory destination,
    List<int> scaledElements,
  ) async {
    final destinationOraPath = destinationOra.path;

    const type = 'picture';
    final id = path.basename(destination.path);
    stack = StackXml.path(path.join(destinationOraPath, 'stack.xml'));
    size = stack.size;

    // aspect size
    final preferredAspect = PreferredAspect(size);
    aspectSize = preferredAspect.preferredAspectSize();
    final sa = aspectSize.toDelimiterString('to');

    // preview path
    final previewSize = thumbnailSize(destinationOraPath);
    final sp = previewSize.toDelimiterString('x');
    final previewPath = '$sa/$sp/canvas';

    final brick = Brick.path(path.join('bricks', 'about'));
    final generator = await MasonGenerator.fromBrick(brick);
    final files = await generator.generate(
      DirectoryGeneratorTarget(destination),
      vars: <String, dynamic>{
        'type': type,
        'id': id,
        'width': size.x.toInt(),
        'height': size.y.toInt(),
        'compositions': '["$sa"]',
        'elements': scaledElements,
        'previews': '["$previewPath"]',
        'ru_name': 'Сказка в лесу',
      },
      fileConflictResolution: FileConflictResolution.overwrite,
    );
    _assertGenerated(files, destination.path);
  }

  void _assertGenerated(List<GeneratedFile> files, String destinationPath) {
    if (files.isEmpty) {
      throw Exception("Can't generate files by path `$destinationPath`.");
    }

    for (final file in files) {
      if (_isFailureGeneratedFileStatus(file.status)) {
        throw Exception("Can't create file `${file.path}`"
            ' by path `$destinationPath`.');
      }
    }
  }

  Future<void> _buildAboutAllLanguagesJson(Directory destination) async {
    final destinationPath = destination.path;

    final aboutLang = AboutLang.path(path.join(sourcePath, 'about'));
    final langFiles = await aboutLang.files;
    for (final langFile in langFiles.entries) {
      final lang = langFile.key;
      final file = langFile.value;
      final json = file.readAsStringSync().jsonMap;

      print('${currentIndent}Build `about_$lang.json`');

      final brick = Brick.path(path.join('bricks', 'about_lang'));
      final generator = await MasonGenerator.fromBrick(brick);
      final files = await generator.generate(
        DirectoryGeneratorTarget(Directory(destinationPath)),
        vars: <String, dynamic>{
          'lang': lang,
          'name': json['name'],
          'masterminds': (json['masterminds'] as List<dynamic>).sjson,
          'artists': (json['artists'] as List<dynamic>).sjson,
          'animators': (json['animators'] as List<dynamic>).sjson,
          'thanks': (json['thanks'] as List<dynamic>).sjson,
        },
        fileConflictResolution: FileConflictResolution.overwrite,
      );
      if (files.isEmpty) {
        throw Exception("Can't generate files by path `$destinationPath`.");
      }

      for (final file in files) {
        if (_isFailureGeneratedFileStatus(file.status)) {
          throw Exception("Can't create file `${file.path}`"
              ' by path `$destinationPath`.');
        }
      }
    }
  }

  String get previewPath => path.join(
        aspectSize.toDelimiterString('to'),
        previewSize.toDelimiterString('x'),
        'canvas.webp',
      );

  File thumbnailFile(String destinationPath) => File(path.join(
        destinationPath,
        'Thumbnails',
        'thumbnail.png',
      ));

  Vector2 thumbnailSize(String destinationPath) {
    final file = thumbnailFile(destinationPath);
    assert(file.existsSync());
    final bytes = file.readAsBytesSync();
    final image = decodeImage(bytes)!;

    return Vector2(image.width.toDouble(), image.height.toDouble());
  }

  Future<void> _buildPreviews(
    Directory destinationOra,
    Directory destination,
  ) async {
    final destinationOraPath = destinationOra.path;
    final destinationPath = destination.path;

    final file = thumbnailFile(destinationOraPath);
    assert(file.existsSync());

    previewSize = thumbnailSize(destinationOraPath);
    final pathToPreview = path.join(
      destinationPath,
      'previews',
      previewPath,
    );
    final pathToPreviewFolder = path.dirname(pathToPreview);
    Directory(pathToPreviewFolder).createSync(recursive: true);
    file.copySync(pathToPreview);
  }

  Future<void> _buildElements(
    Directory destinationOra,
    String state,
    Directory destination,
    List<int> scaledElements,
  ) async {
    final destinationOraPath = destinationOra.path;
    final destinationPath = destination.path;

    // prepare map for convert file name to layer name
    final layerMap = stack.layerSourceNameMap;
    print('${currentIndent}LayerMap contains ${layerMap.length} elements.');

    // copy and scale
    for (final scaledElement in scaledElements) {
      increaseCurrentIndent();
      await _buildElement(
        destinationOraPath,
        state,
        destinationPath,
        scaledElement,
      );
      decreaseCurrentIndent();
    }
  }

  Future<void> _buildElement(
    String destinationOraPath,
    String state,
    String destinationPath,
    int scaledElement,
  ) async {
    final pathToScaled = path.join(
      destinationPath,
      'elements',
      '$scaledElement',
    );
    print('${currentIndent}Path for scaled to $scaledElement%'
        ' is `$pathToScaled`.');
    Directory(pathToScaled).createSync(recursive: true);

    increaseCurrentIndent();

    print('${currentIndent}Looking at layers'
        ' from `${stack.file.path}`...');
    final layerMap = stack.layerSourceNameMap;
    print('${currentIndent}Found ${layerMap.length} layer(s)'
        ' into the `${stack.file.path}`.');
    for (final sn in layerMap.entries) {
      final source = sn.key;
      final name = sn.value;
      assert(source.isNotEmpty);
      assert(name.isNotEmpty);

      // copy sprites
      final pathFrom = path.join(destinationOraPath, source);
      final file = File(pathFrom);
      assert(file.existsSync());
      final pathToNameState = path.join(pathToScaled, name, state);
      Directory(pathToNameState).createSync(recursive: true);
      final pathToFile = path.join(pathToNameState, '$name.webp');
      print('${currentIndent}Copy `$pathFrom` to `$pathToFile`.');
      file.copySync(pathToFile);

      // scale sprites
      if (scaledElement != 100) {
        final scale = scaledElement / 100;
        _scaleImage(pathToFile, scale);
      }
    }

    // copy sounds
    final pathToSounds = path.join(sourcePath, 'sounds', state);
    print('${currentIndent}Looking at sounds'
        ' by path `$pathToSounds`...');
    final soundsFiles = await allFilesFromDirectory(Directory(pathToSounds));
    print('${currentIndent}Found ${soundsFiles.length} sound(s)'
        ' by path `$pathToSounds`.');
    for (final soundFile in soundsFiles) {
      if (!soundFile.path.endsWith('.mp3')) {
        // skip a non-mp3 extension
        print("$currentIndent?) File `${soundFile.path}` hasn't an"
            ' mp3 extension. Skipped.');
        continue;
      }

      final pathFrom = soundFile.path;
      final basename = path.basenameWithoutExtension(pathFrom);
      final separated = basename.split('_');
      if (separated.length < 2) {
        print("$currentIndent?) File `$pathFrom` hasn't a"
            ' correct name. Skipped.');
        continue;
      }

      separated.removeLast();
      final elementName = separated.join('_');

      final pathToNameState = path.join(pathToScaled, elementName, state);
      if (!Directory(pathToNameState).existsSync()) {
        print("$currentIndent?) Can't found a created early sprite"
            ' for sound `$basename`'
            ' by path `$pathToNameState`. Skipped.');
        continue;
      }

      final pathToFile = path.join(pathToNameState, path.basename(pathFrom));
      print('${currentIndent}Copy `$pathFrom` to `$pathToFile`.');
      final file = File(pathFrom);
      assert(file.existsSync());
      file.copySync(pathToFile);
    }

    // copy animations
    final pathToAnimations = path.join(sourcePath, 'animations');
    print('${currentIndent}Looking at animations'
        ' by path `$pathToAnimations`...');
    final animationsFiles =
        await allFilesFromDirectory(Directory(pathToAnimations));
    print('${currentIndent}Found ${animationsFiles.length} animation(s)'
        ' by path `$pathToAnimations`.');
    for (final animationFile in animationsFiles) {
      final isAtlas = animationFile.path.endsWith('.atlas');
      final isJson = animationFile.path.endsWith('.json');
      final isTexture = animationFile.path.endsWith('.png');
      if (!isAtlas && !isJson && !isTexture) {
        // skip a non-animation extension
        print("$currentIndent?) File `${animationFile.path}` hasn't an"
            ' one of animation extensions. Skipped.');
        continue;
      }

      final pathFrom = animationFile.path;
      final elementName = path.basenameWithoutExtension(pathFrom);
      // all animations states contain into the one json +atlas +png file
      final pathToNameState = path.join(pathToScaled, elementName);
      if (!Directory(pathToNameState).existsSync()) {
        print("$currentIndent?) Can't found a created early sprite"
            ' for `${path.basename(pathFrom)}`'
            ' by path `$pathToNameState`. Skipped.');
        continue;
      }

      final basenameFrom = path.basename(pathFrom);
      var pathToFile = path.join(pathToNameState, basenameFrom);
      if (isTexture) {
        pathToFile = pathToFile.replaceFirst('.png', '.webp');
      }
      print('${currentIndent}Copy `$pathFrom` to `$pathToFile`.');
      final file = File(pathFrom);
      assert(file.existsSync());
      file.copySync(pathToFile);

      if (isAtlas) {
        final basename = path.basenameWithoutExtension(pathFrom);
        final basenameFrom = '$basename.png';
        final basenameTo = '$basename.webp';
        print('${currentIndent}Replace into the atlas:'
            ' `$basenameFrom` -> `$basenameTo`.');
        final copiedFile = File(pathToFile);
        assert(copiedFile.existsSync());
        final replacedContent = copiedFile
            .readAsStringSync()
            .replaceFirst(basenameFrom, basenameTo);
        copiedFile.writeAsStringSync(replacedContent);
      }
    }

    // create a file for optimize delivery from cloud
    final pathToOptimizeDelivery = '$pathToScaled.exists';
    print('${currentIndent}Create file `$pathToOptimizeDelivery`'
        ' for optimize cloud delivery.');
    File(pathToOptimizeDelivery).createSync();

    // archive scaled folder
    print('${currentIndent}Zip folder `$pathToScaled`.');
    final zipEncoder = ZipFileEncoder();
    const level = Deflate.BEST_COMPRESSION;
    zipEncoder.create('$pathToScaled.zip', level: level);
    zipEncoder.addDirectory(
      Directory(pathToScaled),
      includeDirName: true,
      level: level,
    );
    zipEncoder.close();

    decreaseCurrentIndent();
  }

  Future<void> _buildComposition(Directory destination) async {
    final destinationPath = destination.path;

    const type = 'picture';
    final id = path.basename(destinationPath);

    final ws = <Map<String, dynamic>>[];
    const sm = 'GreyColorPlay';
    final namePositionMap = stack.layerNamePositionMap;
    for (final sn in namePositionMap.entries) {
      final name = sn.key;
      final position = sn.value;
      assert(name.isNotEmpty);

      ws.add(<String, dynamic>{
        'name': name,
        'position': position.toDelimiterString(),
        'sm': sm,
        'last': false,
      });
    }
    ws.last['last'] = true;

    final brick = Brick.path(path.join('bricks', 'compositions'));
    final generator = await MasonGenerator.fromBrick(brick);
    final files = await generator.generate(
      DirectoryGeneratorTarget(destination),
      vars: <String, dynamic>{
        'w': aspectSize.x.toInt(),
        'h': aspectSize.y.toInt(),
        'type': type,
        'name': id,
        'width': size.x.toInt(),
        'height': size.y.toInt(),
        'ws_count': ws.length,
        'ws': ws,
      },
      fileConflictResolution: FileConflictResolution.overwrite,
    );
    _assertGenerated(files, destination.path);
  }

  Future<void> _removeUnusedFoldersAndFiles(
    Directory destination,
    List<int> scaledElements,
  ) async {
    final destinationPath = destination.path;

    const unusedFolders = <String>[
      'sprites',
    ];
    unusedFolders.forEach((folder) =>
        Directory('$destinationPath/$folder').deleteSync(recursive: true));

    const unusedFiles = <String>[];
    unusedFiles.forEach(
        (file) => File('$destinationPath/$file').deleteSync(recursive: true));

    // elements
    scaledElements.forEach((se) =>
        Directory('$destinationPath/elements/$se').deleteSync(recursive: true));
  }

  void _scaleImage(String pathTo, double scale) {
    final file = File(pathTo);
    assert(file.existsSync());
    final bytes = file.readAsBytesSync();
    final image = decodeImage(bytes)!;
    final width = image.width * scale;
    final height = image.height * scale;
    final scaled = copyResize(
      image,
      width: width.toInt(),
      height: height.toInt(),
      interpolation: Interpolation.nearest,
    );

    // TODO Add a compress to WEBP format.
    final encoded = encodePng(scaled);
    file.writeAsBytesSync(encoded, flush: true);
  }

  bool _isOkGeneratedFileStatus(GeneratedFileStatus status) => [
        GeneratedFileStatus.created,
        GeneratedFileStatus.overwritten,
        GeneratedFileStatus.identical,
      ].contains(status);

  bool _isFailureGeneratedFileStatus(GeneratedFileStatus status) =>
      !_isOkGeneratedFileStatus(status);

  String indent(int n) => (n > 0) ? '\t' * n : '';

  int currentIndentValue = 1;

  String get currentIndent => indent(currentIndentValue);

  void resetCurrentIndent() => currentIndentValue = 1;

  void increaseCurrentIndent() => ++currentIndentValue;

  void decreaseCurrentIndent() => --currentIndentValue;
}
