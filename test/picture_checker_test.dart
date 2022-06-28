import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/card_checker.dart';

import 'init_test_environment.dart';

void main() {
  initTestEnvironment();

  const paths = <String>[
    // compositions
    '16to7.json',
    '/16to7.json',
    '/storage/emulated/0/data/cache/pc/fox_and_fish/16to7.json',
    '/9to16.json',
    '/1to1.json',
    // downloaded info
    'downloaded_info.json',
    '/downloaded_info.json',
    '/storage/emulated/0/data/cache/pc/fox_and_fish/downloaded_info.json',
    // previews
    '16to7/256x112/canvas.webp',
    '/16to7/256x112/canvas.webp',
    '/storage/emulated/0/data/cache/pc/fox_and_fish/previews/16to7/256x112/canvas.webp',
    '/9to16/256x144/canvas.webp',
    '/1to1/256x256/canvas.webp',
    // path to sprites and animations
    '/storage/emulated/0/data/cache/pc/fox_and_fish/sprites/bird.webp',
    'storage/emulated/0/data/cache/pc/fox_and_fish/sprites/flower_1.webp',
    'sprites/bird',
    'sprites/flower_1.webp',
    'sprites/flower_1',
    '/sprites/bird',
    '/sprites/flower_1.webp',
    '/sprites/flower_1',
    // sprites and animations
    '/storage/emulated/0/data/cache/pc/fox_and_fish/sprites/bird.webp',
    'storage/emulated/0/data/cache/pc/fox_and_fish/sprites/flower_1.webp',
    'bird',
    'flower_1.webp',
    'flower_1',
    // others
    '',
    ' ',
    '...',
    '/',
    '//',
    '.',
    './',
    // fail compositions
    '/16to7.json ',
    ' /16to7.json',
    '/ 16to7.json',
    '/16to7_json',
    '/16to7.json/',
    '/16to7.json1',
    '/16to7.json/some/other.json',
    '/1x1.json',
    '/1to1',
    '/1t1',
    '/11',
    '_16to7.json',
    '16to7,json',
    '16to7_json',
    '16to7-json',
    // fail downloaded info
    '/downloaded_info.json ',
    ' /downloaded_info.json',
    '/ downloaded_info.json',
    '/downloaded_info_json',
    '/downloaded_info.json/',
    '/downloaded_info.json/some/other.json',
    '/loaded_info.json',
    // fail previews
    '/preview_16to7.webp ',
    ' /preview_16to7.webp',
    '/ preview_16to7.webp',
    '/preview_16to7_webp',
    '/preview_16to7.webp/',
    '/preview_16to7.webp1',
    '/preview_16to7.webp/some/other.webp',
    '/preview_1x1.webp',
    '/preview_1to1',
    '/preview_1t1',
    '/preview_11',
    'review_16to7.webp',
    // fail sprites and animations
    'flower_1.jpg',
    ' flower_1.webp',
    'flower_1.webp ',
    ' flower_1 ',
    'flower_1 ',
  ];

  test('PictureCheckerAspectSizeOnStringExtension.isPathToComposition', () {
    final counts = paths.where((p) => p.isPathToComposition).length;
    expect(counts, 5);
  });

  test('PictureCheckerAspectSizeOnStringExtension.isPathToDownloadedInfo', () {
    final counts = paths.where((p) => p.isPathToDownloadedInfo).length;
    expect(counts, 3);
  });

  test('PictureCheckerAspectSizeOnStringExtension.isPathToPreview', () {
    final counts = paths.where((p) => p.isPathToPreview).length;
    expect(counts, 5);
  });
}
