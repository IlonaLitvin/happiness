import 'dart:async';

import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const InitAppState()) {
    if (C.debugBloc) {
      Fimber.i('AppBloc start');
    }

    on<InitAppEvent>(_onInit);
    on<ConnectToFirebaseAppEvent>(_onConnectingToFirebase);
  }

  void _onInit(
    InitAppEvent event,
    Emitter<AppState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    // \test
    await pause();

    emit(const InitAppState());
  }

  void _onConnectingToFirebase(
    ConnectToFirebaseAppEvent event,
    Emitter<AppState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    // \test
    await pause();

    // \see https://firebase.flutter.dev/docs/overview/#initializing-flutterfire
    emit(await initializeFlutterFire()
        ? const SuccessConnectedToFirebaseAppState()
        : const FailureConnectedToFirebaseAppState());
  }

  Future<bool> initializeFlutterFire() async {
    try {
      // \todo fine Make it with new version. See the project `path_cell`.
      await Firebase.initializeApp(options: C.firebaseOptions);
      final app = Firebase.app();
      if (C.debugBloc) {
        Fimber.i('Firebase App initialized with name `${app.name}`.'
            '\n${app.toString()}');
      }
    } catch (ex) {
      Fimber.e('Error when initializing Firebase', ex: ex);
      return false;
    }

    return true;
  }
}
