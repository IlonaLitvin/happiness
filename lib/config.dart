import 'dart:io' show Directory, Platform;

import 'package:adaptive_ui/ext.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'how_to_get/scope/cost/cost_type.dart';

typedef C = Config;

class Config {
  /// Design size for nice visible text.
  /// \see https://pub.dev/packages/adaptive_ui
  /// Virtual device: Pixel 2 API 30 | 5" | 1080 x 1920: 420 dpi.
  /// \see defaultFontSize
  static final designSize = Vector2(731, 411);

  /// \see https://revenuecat.com
  static const purchase = _PurchaseWrapper(
    publicAppKeyApple: 'appl_DHVZSNkeSKBDMyiAYcPMsrJRhLn',
    publicAppKeyGoogle: 'goog_VRpNfwSZyfZWiOwSYOwPKXtgedi',
    entitlementPro: 'pro',
    productIdSubscribeAnnual: 'hp.1099.1y',
    productIdSubscribeMonthly: 'hp.199.1m',
  );

  /// Because for Apple we have a direct pay App.
  /// \see https://signmotion.atlassian.net/browse/HP-483
  static const ignoreCostTypesForApple = <CostType>[CostType.subscribe_store];

  /// IDs in the stores.
  /// \see https://pub.dev/packages/in_app_review
  static const appStoreId = '1601466169';

  /// App title before context will initialize.
  /// \see `ActiveLocalization(context).localization.app_title`
  static const defaultAppTitle = 'Happiness';

  /// Social links.
  static const facebookLink = 'https://m.me/happiness.noisy.studio';
  static const telegramLink = 'https://t.me/happiness_app';

  static const defaultLocale = Locale('en');
  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uk'),
  ];

  static const allowedAudioFileExtension = 'mp3';
  static const allowedDataFileExtension = 'json';
  static const allowedImageFileExtension = 'webp';

  /// To detect from the App whether the folder exists.
  static const detectExistsFolderExtension = 'exists';

  /// To detect from the App whether this named folder exists.
  /// The existence of this file guarantees that the folder with the given name
  /// is present in this folder hierarchy.
  /// \warning Be careful. If this folder is local and not included
  /// in the `pubspec.yaml`, including all folders inside it, the files
  /// will not be found.
  static String detectExistsFolderFile(String folder) =>
      '$folder.$detectExistsFolderExtension';

  static const assetsFolder = 'assets';
  static const assetsFontsFolder = 'fonts';
  static const assetsImagesFolder = 'images';

  static const cardsFile = '$cardsFileName.$cardsFileExtension';
  static const cardsFileName = 'cards';
  static const cardsFileExtension = allowedDataFileExtension;

  static const cardsFolderSuffix = '_cards';

  /// \todo fine `aboutFile = ` and remove all variables kind `C.xxxExtension`.
  static const aboutFolder = 'about';
  static const compositionsFolder = 'compositions';
  static const elementsFolder = 'elements';

  static const aboutFileName = aboutFolder;
  static const aboutFileExtension = allowedDataFileExtension;

  static const compositionFileExtension = allowedDataFileExtension;
  static const aspectSizeDelimiter = 'to';

  static const previewFileExtension = allowedImageFileExtension;

  /// \example `girl_and_deer/previews/4to3/256x192/canvas.webp`
  static const previewsFolder = 'previews';

  static const pictureCardsFolder = 'picture_cards';

  /// For hide partially visible elements.
  static const alwaysShowWholePicture = false;

  static const laterCardsFolder = 'later_cards';
  static const welcomeCardsFolder = 'welcome_cards';

  static const maxCountSounds = 3;

  static const localStorageFolder = 'storage';

  /// Essential file for scale downloaded picture.
  static const downloadedInfoFile =
      '$downloadedInfoFileName.$downloadedInfoFileExtension';
  static const downloadedInfoFileName = 'downloaded_info';
  static const downloadedInfoFileExtension = allowedDataFileExtension;

  static const previewBlurSigma = 25.0;
  static const fastAnimatedBlurSigma = 120.0;
  static const fastAnimatedBlurDuration = Duration(milliseconds: 1200);
  static const longAnimatedBlurSigma = 240.0;
  static const longAnimatedBlurDuration = Duration(milliseconds: 12000);
  static const smallSizeStayBlurSigma = 6.0;

  /// How often events we will take for BLoC.
  static const defaultEventThrottleDuration = Duration(milliseconds: 120);

  static const _projectId = 'happiness-noisy';
  static const _authDomain = 'happiness-noisy.firebaseapp.com';
  static const _databaseURL = 'https://happiness-noisy.firebaseio.com';
  static const _storageBucket = 'happiness-noisy.appspot.com';

  static const _firebaseOptions = <String, FirebaseOptions>{
    'android': FirebaseOptions(
      projectId: _projectId,
      authDomain: _authDomain,
      databaseURL: _databaseURL,
      storageBucket: _storageBucket,
      appId: '1:562198926364:android:86465e3bd498cd8ec5dd59',
      apiKey: 'AIzaSyDCk9K1dTvBakoidoKguQOLsJQA2JVfrSs',
      messagingSenderId: '562198926364',
    ),
    'ios': FirebaseOptions(
      projectId: _projectId,
      authDomain: _authDomain,
      databaseURL: _databaseURL,
      storageBucket: _storageBucket,
      appId: '1:562168981264:ios:3307de4016a52ec7a1ed59',
      apiKey: 'AIzaSyCJowwbjLOScOkaB1Y8lhJiqroM1gDpVsU',
      messagingSenderId: '562168981264',
    ),
  };

  static FirebaseOptions get firebaseOptions {
    final os = _firebaseOptions[Platform.operatingSystem];
    if (os != null) {
      return os;
    }

    throw "Can't found the Firebase options for"
        ' this operating system: `$os`.';
  }

  /// \see [designSize]
  static const defaultFontSize = 14;

  static const defaultFontFamily = 'Pacifico';

  static const defaultButtonTextColor = Colors.white;
  static const defaultButtonBackgroundColor = Colors.blueAccent;

  static TextStyle get defaultButtonTextStyle => defaultTextStyle.copyWith(
        color: defaultButtonTextColor,
        backgroundColor: defaultButtonBackgroundColor,
        fontSize: defaultBottomFontSizeRelative,
      );

  static double get defaultFontSizeRelative =>
      defaultFontSize.sp.roundToDouble();

  static double get defaultBottomFontSize =>
      (defaultFontSize * 2 / 3).roundToDouble();

  static double get defaultBottomFontSizeRelative =>
      defaultBottomFontSize.sp.roundToDouble();

  static TextStyle get defaultTextStyle => TextStyle(
        fontFamily: defaultFontFamily,
        fontSize: defaultFontSizeRelative,
        color: Colors.black,
      );

  static TextStyle get bottomTextStyle => defaultTextStyle.copyWith(
        //fontFamily: 'sans-serif',
        fontSize: defaultBottomFontSizeRelative,
        color: Colors.white38,
      );

  static double get dialogAnswerFontSizeRelative => defaultFontSizeRelative * 2;

  static TextStyle get dialogAnswerTextStyle => defaultTextStyle.copyWith(
        fontSize: dialogAnswerFontSizeRelative,
        color: Colors.lightGreenAccent,
      );

  static Widget get delimiterWidget =>
      SizedBox(height: defaultFontSizeRelative);

  /// Look at clouds when file is absent into the local assets.
  static const enableClouds = false;

  /// For debug.
  static const clearCacheWhenAppRestarts = false;
  static const clearStatesWhenAppRestarts = kDebugMode;
  static const ignoreChildProtection = kDebugMode;
  static const throwSomethingWrong = kDebugMode;
  static const showSpriteBox = true;
  static const defaultPauseDuration =
      Duration(milliseconds: debugBloc ? 1000 : 0);
  static const logPeriodFpsInSeconds = 24;

  /// \todo Wrap them to class. See example [_PurchaseWrapper].
  static const debugAnimation = true;
  static const debugAudio = false;
  static const debugBloc = true;
  static const debugEffect = true;
  static const debugFsm = true;
  static const debugCardChecker = true;
  static const debugCardPath = true;
  static const debugLoader = true;
  static const debugPictureSource = true;
  static const debugPurchase = true;
  static const debugSprite = true;

  static bool get isApple => os.isIOS || os.isMacOS;

  static bool get isGoogle => os.isAndroid || os.isFuchsia;

  static const Os os = Os();

  Directory? _appDir;

  Future<Directory?> get appDir async => _appDir ??= await chooseAppDir;

  /// Choose a folder that is as device-friendly as possible.
  static Future<Directory?> get chooseAppDir async {
    try {
      final dirs = await getExternalCacheDirectories();
      if (dirs != null && dirs.isNotEmpty) {
        Fimber.i('Selected ExternalCacheDirectory `$dirs`');
        return dirs.first;
      }
    } catch (ex) {
      // it's not fatal
    }

    try {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        Fimber.i('Selected ExternalStorageDirectory `$dir`');
        return dir;
      }
    } catch (ex) {
      // it's not fatal
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      Fimber.i('Selected ApplicationDocumentsDirectory `$dir`');
      return dir;
    } catch (ex) {
      // it's not fatal
    }

    Fimber.w("Doesn't detect the app directory.");

    return null;
  }

  static Future<Directory?> get appLocalStorageDir async {
    final dir = await chooseAppDir;
    if (dir == null) {
      return null;
    }

    final r = Directory('${dir.absolute.path}/$localStorageFolder');
    try {
      r.createSync(recursive: true);
    } catch (ex) {
      Fimber.e("Can't create a path `$r`.", ex: ex);
      return null;
    }

    return r;
  }
}

class _PurchaseWrapper {
  /// Public app-specific API keys.
  /// Get the keys: https://app.revenuecat.com/projects/7353a3c5/api-keys
  String get publicAppKey =>
      C.isApple ? _publicAppKeyApple : _publicAppKeyGoogle;

  final String _publicAppKeyApple;
  final String _publicAppKeyGoogle;

  /// Products for purchases.
  /// \see https://docs.revenuecat.com/docs/entitlements
  final String entitlementPro;

  final String productIdSubscribeAnnual;
  final String productIdSubscribeMonthly;

  bool get isSubscriptionAutoRenewing => !C.isApple;

  const _PurchaseWrapper({
    required String publicAppKeyGoogle,
    required String publicAppKeyApple,
    required this.entitlementPro,
    required this.productIdSubscribeAnnual,
    required this.productIdSubscribeMonthly,
  })  : assert(publicAppKeyApple.length > 0),
        assert(publicAppKeyGoogle.length > 0),
        assert(entitlementPro.length > 0),
        assert(productIdSubscribeAnnual.length > 0),
        assert(productIdSubscribeMonthly.length > 0),
        _publicAppKeyGoogle = publicAppKeyGoogle,
        _publicAppKeyApple = publicAppKeyApple;
}

/// Wrapper for avoid conflicts and required prefixes for resolve package
/// conflicts.
/// Use [Config.os] for access to const instance.
class Os {
  const Os();

  bool get isAndroid => Platform.isAndroid;

  bool get isFuchsia => Platform.isFuchsia;

  bool get isIOS => Platform.isIOS;

  bool get isLinux => Platform.isLinux;

  bool get isMacOS => Platform.isMacOS;

  bool get isWindows => Platform.isWindows;
}
