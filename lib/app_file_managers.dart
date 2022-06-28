import 'dart:io';
import 'dart:ui' as ui;

import 'package:cross_file_manager/cross_file_manager.dart';
import 'package:flutter/widgets.dart' as widgets;

import 'config.dart';

class AppFileManagerCloudPriorityWithoutArchive {
  static final _instance = AppFileManagerCloudPriorityWithoutArchive._();

  static final crossFileManager = CrossFileManager.create(
    // local priority without archive
    loaders: const [
      // \todo Extend with downloads from cloud: GoogleDrive, OneDrive, etc.
      if (C.enableClouds) CachedPlainFirebaseLoader(),
      if (C.enableClouds) PlainFirebaseLoader(),
      PlainAssetsLoader(),
    ],
    needClearCache: C.clearCacheWhenAppRestarts,
    log: C.debugLoader ? li : liSilent,
  );

  factory AppFileManagerCloudPriorityWithoutArchive() => _instance;

  AppFileManagerCloudPriorityWithoutArchive._();

  Future<bool> exists(String path, {List<Loader>? loaders}) async =>
      (await crossFileManager).exists(path, loaders: loaders);

  Future<bool> existsInCache(String path, {List<Loader>? loaders}) async =>
      (await crossFileManager).existsInCache(path, loaders: loaders);

  Future<File?> loadFile(String path) async =>
      (await crossFileManager).loadFile(path);

  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
  }) async =>
      (await crossFileManager).loadImageWidget(
        path,
        width: width,
        height: height,
      );

  Future<String?> loadString(String path) async =>
      (await crossFileManager).loadString(path);

  Future<bool> warmUp(String path) async =>
      (await crossFileManager).warmUp(path);

  Future<void> clearCache() async => (await crossFileManager).clearCache();
}

class AppFileManagerLocalPriority {
  static final _instance = AppFileManagerLocalPriority._();

  static final crossFileManager = CrossFileManager.create(
    // local priority without archive
    loaders: const [
      PlainAssetsLoader(),
      if (C.enableClouds) CachedPlainFirebaseLoader(),
      ZipAssetsLoader(),
      if (C.enableClouds) CachedZipFirebaseLoader(),
      // \warning Verify rules and AppCheck if access to storage is denied.
      // \see https://stackoverflow.com/questions/68441059/no-app-check-token-for-request-futter-firebase-error
      if (C.enableClouds) PlainFirebaseLoader(),
      if (C.enableClouds) ZipFirebaseLoader(),
      // \todo Extend with downloads from cloud: GoogleDrive, OneDrive, etc.
    ],
    needClearCache: C.clearCacheWhenAppRestarts,
    log: C.debugLoader ? li : liSilent,
  );

  factory AppFileManagerLocalPriority() => _instance;

  AppFileManagerLocalPriority._();

  Future<bool> exists(String path, {List<Loader>? loaders}) async =>
      (await crossFileManager).exists(path, loaders: loaders);

  Future<bool> existsInCache(String path, {List<Loader>? loaders}) async =>
      (await crossFileManager).existsInCache(path, loaders: loaders);

  Future<File?> loadFile(String path) async =>
      (await crossFileManager).loadFile(path);

  Future<ui.Image?> loadImageUi(String path) async =>
      (await crossFileManager).loadImageUi(path);

  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
  }) async =>
      (await crossFileManager).loadImageWidget(
        path,
        width: width,
        height: height,
      );

  Future<String?> loadString(String path) async =>
      (await crossFileManager).loadString(path);

  Future<bool> warmUp(String path) async =>
      (await crossFileManager).warmUp(path);

  Future<void> clearCache() async => (await crossFileManager).clearCache();
}
