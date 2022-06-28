import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config.dart';

class AppObserver extends BlocObserver {
  @mustCallSuper
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    if (C.debugBloc) {
      Fimber.i('$event for $bloc');
    }
  }

  @mustCallSuper
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    if (C.debugBloc) {
      Fimber.i('$transition');
    }
  }

  @mustCallSuper
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    Fimber.i('$error');
  }

  @mustCallSuper
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    if (C.debugBloc) {
      Fimber.i('$bloc');
    }
  }
}
