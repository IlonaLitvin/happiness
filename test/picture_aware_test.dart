import 'package:dart_helpers/dart_helpers.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness/card_aware.dart';

import 'init_test_environment.dart';

void main() {
  initTestEnvironment();

  test('bestScale()', () {
    // original size of picture
    final os = Vector2(5000, 3000);

    // available scales
    // respects sizes:
    //   100: 5000 3000
    //    50: 2500 1500
    //    25: 1250  750
    //    10:  500  300
    //     1:    5    3
    const many = <int>[100, 50, 25, 10, 1];

    const one100 = <int>[100];
    const one50 = <int>[50];
    const one1 = <int>[1];

    // \TODO
    //const empty = <Size>[];

    /* \TODO
    const illegal1 = <int>[10, 20, 100];
    const illegal2 = <int>[100, 50, 70, 20];
    const illegal3 = <int>[0, 50, 100];
    const illegal4 = <int>[100, 50, 0];
    const illegal5 = <int>[1000];
    const illegal6 = <int>[0];
    const illegal7 = <int>[-10];
    */

    final data = <BestScaleTestData>[
      // many
      BestScaleTestData(Vector2(100, 100), os, many, 10),
      BestScaleTestData(Vector2(499, 300), os, many, 10),
      BestScaleTestData(Vector2(500, 300), os, many, 10),
      BestScaleTestData(Vector2(500, 299), os, many, 10),
      BestScaleTestData(Vector2(500, 301), os, many, 25),
      BestScaleTestData(Vector2(501, 300), os, many, 25),
      BestScaleTestData(Vector2(500, 400), os, many, 25),
      BestScaleTestData(Vector2(600, 300), os, many, 25),
      BestScaleTestData(Vector2(4999, 100), os, many, 100),
      BestScaleTestData(Vector2(6000, 100), os, many, 100),
      BestScaleTestData(Vector2(6000, 100), os, many, 100),
      BestScaleTestData(Vector2(100, 2999), os, many, 100),
      BestScaleTestData(Vector2(100, 4000), os, many, 100),
      BestScaleTestData(Vector2(70000, 90000), os, many, 100),
      BestScaleTestData(Vector2(2500, 3), os, many, 50),
      BestScaleTestData(Vector2(5, 1500), os, many, 50),
      // one100
      BestScaleTestData(Vector2(100, 100), os, one100, 100),
      BestScaleTestData(Vector2(1, 1), os, one100, 100),
      BestScaleTestData(Vector2(2500, 1500), os, one100, 100),
      BestScaleTestData(Vector2(5000, 3000), os, one100, 100),
      BestScaleTestData(Vector2(4999, 3000), os, one100, 100),
      BestScaleTestData(Vector2(5000, 2999), os, one100, 100),
      BestScaleTestData(Vector2(50000, 3000), os, one100, 100),
      BestScaleTestData(Vector2(5000, 30000), os, one100, 100),
      BestScaleTestData(Vector2(50000, 30000), os, one100, 100),
      // one50
      BestScaleTestData(Vector2(100, 100), os, one50, 50),
      BestScaleTestData(Vector2(1, 1), os, one50, 50),
      BestScaleTestData(Vector2(2500, 1500), os, one50, 50),
      BestScaleTestData(Vector2(5000, 3000), os, one50, 50),
      BestScaleTestData(Vector2(4999, 3000), os, one50, 50),
      BestScaleTestData(Vector2(5000, 2999), os, one50, 50),
      BestScaleTestData(Vector2(50000, 3000), os, one50, 50),
      BestScaleTestData(Vector2(5000, 30000), os, one50, 50),
      BestScaleTestData(Vector2(50000, 30000), os, one50, 50),
      // one1
      BestScaleTestData(Vector2(100, 100), os, one1, 1),
      BestScaleTestData(Vector2(1, 1), os, one1, 1),
      BestScaleTestData(Vector2(2500, 1500), os, one1, 1),
      BestScaleTestData(Vector2(5000, 3000), os, one1, 1),
      BestScaleTestData(Vector2(4999, 3000), os, one1, 1),
      BestScaleTestData(Vector2(5000, 2999), os, one1, 1),
      BestScaleTestData(Vector2(50000, 3000), os, one1, 1),
      BestScaleTestData(Vector2(5000, 30000), os, one1, 1),
      BestScaleTestData(Vector2(50000, 30000), os, one1, 1),
    ];

    for (final d in data) {
      final bestScale = CardAware.bestScale(
        d.screenSize,
        d.originalSize,
        d.availableScales,
      );
      expect(bestScale, d.expectedScale,
          reason: 'for screen size ${d.screenSize.s0},'
              ' original size ${d.originalSize.s0} and'
              ' available scales ${d.availableScales}');
    }
  });

  test('resolutionDivider()', () {
    final pictureSizesMany = <Vector2>[
      Vector2(1500, 1000),
      Vector2(6000, 4000),
      Vector2(3000, 2000),
      Vector2(750, 500),
    ];

    final pictureSizesOne = <Vector2>[
      Vector2(1500, 1000),
    ];

    const pictureSizesEmpty = <Vector2>[];

    final data = <BestSizeTestData>[
      // many
      BestSizeTestData(Vector2(100, 100), pictureSizesMany, Vector2(750, 500)),
      BestSizeTestData(Vector2(700, 100), pictureSizesMany, Vector2(750, 500)),
      BestSizeTestData(Vector2(750, 100), pictureSizesMany, Vector2(750, 500)),
      BestSizeTestData(
          Vector2(1000, 100), pictureSizesMany, Vector2(1500, 1000)),
      BestSizeTestData(
          Vector2(1400, 100), pictureSizesMany, Vector2(1500, 1000)),
      BestSizeTestData(
          Vector2(1500, 100), pictureSizesMany, Vector2(1500, 1000)),
      BestSizeTestData(
          Vector2(1600, 100), pictureSizesMany, Vector2(3000, 2000)),
      BestSizeTestData(
          Vector2(3100, 100), pictureSizesMany, Vector2(6000, 4000)),
      BestSizeTestData(
          Vector2(4500, 100), pictureSizesMany, Vector2(6000, 4000)),
      BestSizeTestData(
          Vector2(6000, 100), pictureSizesMany, Vector2(6000, 4000)),
      BestSizeTestData(
          Vector2(7000, 100), pictureSizesMany, Vector2(6000, 4000)),
      // one
      BestSizeTestData(
          Vector2(1000, 100), pictureSizesOne, Vector2(1500, 1000)),
      BestSizeTestData(
          Vector2(1500, 100), pictureSizesOne, Vector2(1500, 1000)),
      BestSizeTestData(
          Vector2(1400, 100), pictureSizesOne, Vector2(1500, 1000)),
      // empty
      BestSizeTestData(Vector2(1000, 100), pictureSizesEmpty, null),
    ];

    for (final d in data) {
      final bestSize = CardAware.bestSize(d.screenSize, d.pictureSizes);
      expect(bestSize, d.expectedPictureSize,
          reason: 'for screen size ${d.screenSize.s0}'
              ' and picture sizes ${d.pictureSizes}');
    }
  });

  test('resolutionDividerForSize()', () {
    final sizesMany = <Vector2>[
      Vector2(1500, 1000),
      Vector2(6000, 4000),
      Vector2(375, 250),
      Vector2(3000, 2000),
      Vector2(750, 500),
    ];

    final sizesOne = <Vector2>[
      Vector2(1500, 1000),
    ];

    const sizesEmpty = <Vector2>[];

    final data = <ResolutionDividerTestData>[
      // many
      ResolutionDividerTestData(Vector2(7777, 777), sizesMany, 0),
      ResolutionDividerTestData(Vector2(6000, 100), sizesMany, 0),
      ResolutionDividerTestData(Vector2(6000, 4000), sizesMany, 1),
      ResolutionDividerTestData(Vector2(4444, 4444), sizesMany, 0),
      ResolutionDividerTestData(Vector2(3000, 2000), sizesMany, 2),
      ResolutionDividerTestData(Vector2(2222, 2222), sizesMany, 0),
      ResolutionDividerTestData(Vector2(1500, 1000), sizesMany, 4),
      ResolutionDividerTestData(Vector2(1111, 1111), sizesMany, 0),
      ResolutionDividerTestData(Vector2(750, 500), sizesMany, 8),
      ResolutionDividerTestData(Vector2(666, 666), sizesMany, 0),
      ResolutionDividerTestData(Vector2(375, 250), sizesMany, 16),
      ResolutionDividerTestData(Vector2(222, 222), sizesMany, 0),
      // one
      ResolutionDividerTestData(Vector2(2222, 2222), sizesOne, 0),
      ResolutionDividerTestData(Vector2(1500, 1000), sizesOne, 1),
      ResolutionDividerTestData(Vector2(1111, 1111), sizesOne, 0),
      // empty
      ResolutionDividerTestData(Vector2(0, 0), sizesEmpty, 0),
      ResolutionDividerTestData(Vector2(1111, 1111), sizesEmpty, 0),
    ];

    for (final d in data) {
      final resolutionDivider =
          CardAware.resolutionDividerForSize(d.size, d.sizes);
      expect(resolutionDivider, d.expectedResolutionDivider,
          reason: 'for size ${d.size.s0}'
              ' and sizes ${d.sizes}');
    }
  });

  test('preferredAspectSize()', () {
    // <pictureSize, expectedAspectSize>
    final data = <Vector2, Vector2>{
      // landscape
      Vector2(16, 1): Vector2(16, 7),
      Vector2(16, 2): Vector2(16, 7),
      Vector2(16, 3): Vector2(16, 7),
      Vector2(16, 5): Vector2(16, 7),
      Vector2(16, 7): Vector2(16, 7),
      //
      // \todo Vector2(16, 8): Vector2(16, 9),
      Vector2(16, 9): Vector2(16, 9),
      Vector2(16, 10): Vector2(16, 9),
      //
      Vector2(16, 11): Vector2(4, 3),
      Vector2(16, 13): Vector2(4, 3),
      //
      Vector2(16, 15): Vector2(1, 1),
      Vector2(16, 16): Vector2(1, 1),
      Vector2(16, 17): Vector2(1, 1),
      //
      Vector2(16, 20): Vector2(3, 4),
      //
      Vector2(16, 25): Vector2(9, 16),
      Vector2(16, 30): Vector2(9, 16),
      //
      // \todo Vector2(16, 32): Vector2(7, 16),
      Vector2(16, 40): Vector2(7, 16),
      Vector2(16, 50): Vector2(7, 16),
      Vector2(16, 70): Vector2(7, 16),
      Vector2(16, 100): Vector2(7, 16),
      // real devices
      Vector2(411.4, 731.4): Vector2(9, 16),
    };

    // one direction
    data.forEach((pictureSize, expectedAspectSize) {
      final size = CardAware.preferredAspectSize(pictureSize);
      expect(size, expectedAspectSize,
          reason: 'for picture size ${pictureSize.s0}');
    });

    // reverse direction
    data.forEach((pictureSize, expectedAspectSize) {
      final ps = pictureSize.swapped;
      final size = CardAware.preferredAspectSize(ps);
      expect(size, expectedAspectSize.swapped,
          reason: 'for picture size ${ps.s0}');
    });
  });
}

class BestScaleTestData {
  final Vector2 screenSize;
  final Vector2 originalSize;
  final List<int> availableScales;
  final int expectedScale;

  const BestScaleTestData(
    this.screenSize,
    this.originalSize,
    this.availableScales,
    this.expectedScale,
  );
}

class BestSizeTestData {
  final Vector2 screenSize;
  final List<Vector2> pictureSizes;
  final Vector2? expectedPictureSize;

  const BestSizeTestData(
    this.screenSize,
    this.pictureSizes,
    this.expectedPictureSize,
  );
}

class ResolutionDividerTestData {
  final Vector2 size;
  final List<Vector2> sizes;
  final int expectedResolutionDivider;

  const ResolutionDividerTestData(
    this.size,
    this.sizes,
    this.expectedResolutionDivider,
  );
}
