import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app/app_bloc.dart';
import 'app/app_page.dart';
import 'app_observer.dart';
import 'config.dart';
import 'utils.dart';

void main() async {
  Fimber.plantTree(DebugTree.elapsed(useColors: true));

  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
        '${C.assetsFolder}/${C.assetsFontsFolder}/pacifico/ofl.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  Flame.assets.clearCache();

  // implement `toString()` for all equatables
  // \see https://pub.dev/packages/equatable
  EquatableConfig.stringify = true;

  await SystemChrome.setPreferredOrientations([
    // \todo Enable portrait orientation.
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await Flame.device.fullScreen();

  final storageDir =
      kIsWeb ? HydratedStorage.webStorageDirectory : await C.appLocalStorageDir;
  // \todo Add encryption. See HydratedStorage.build(encryptionCipher).
  final blocStorage = storageDir == null
      ? null
      : await HydratedStorage.build(storageDirectory: storageDir);
  if (blocStorage == null) {
    Fimber.w("Can't create a storage for BLoC."
        ' The App states will not be saved.');
  }

  if (C.clearStatesWhenAppRestarts) {
    await blocStorage?.clear();
  }

  HydratedBlocOverrides.runZoned(
    () => runApp(
      BlocProvider(
        create: (context) => AppBloc(),
        child: const AppPage(),
      ),
    ),
    eventTransformer: eventThrottler<dynamic>(),
    storage: blocStorage,
    blocObserver: AppObserver(),
  );
}
