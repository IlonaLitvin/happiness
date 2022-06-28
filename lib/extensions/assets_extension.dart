/*
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import '../config.dart';

extension AssetsExtension on String {
  /// \warning Only local assets. For downloaded files use `isDownloadedExists`.
  /// \see isDownloadedExists
  Future<bool> get isAssetExists async =>
      await isAssetPicturesExists ||
      await isAssetImagesExists ||
      await isAssetRootExists;

  /// \see isAssetExists
  /// \see PictureCheckerAspectSizeOnStringExtension.isDownloadedPath()
  bool get isDownloadedExists => isNotEmpty && File(this).existsSync();

  Future<bool> get isAssetRootExists async {
    if (isEmpty) {
      return false;
    }

    try {
      await rootBundle.load('${C.assetsFolder}/$this');
    } catch (ex) {
      return false;
    }
    return true;
  }

  Future<bool> get isAssetImagesExists async {
    if (isEmpty) {
      return false;
    }

    try {
      await rootBundle
          .load('${C.assetsFolder}/${C.assetsImagesFolder}/$this');
    } catch (ex) {
      return false;
    }
    return true;
  }

  Future<bool> get isAssetPicturesExists async {
    if (isEmpty) {
      return false;
    }

    try {
      await rootBundle
          .load('${C.assetsFolder}/${C.pictureCardsFolder}/$this');
    } catch (ex) {
      return false;
    }
    return true;
  }
}
*/
