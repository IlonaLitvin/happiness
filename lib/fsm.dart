import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:statemachine/statemachine.dart';

import 'config.dart';
import 'state_machine_data.dart';

/// \see https://github.com/renggli/dart-statemachine/blob/master/test/statemachine_test.dart
class FSM extends Machine<String> {
  final controller = StreamController<WAction>.broadcast(sync: true);

  Stream<WAction> get stream => controller.stream;

  String? get stateName => current?.name;

  /// Registers the legal transition from state `b` to `c` by `action`.
  void addTransition(String b, String action, String c) {
    if (C.debugFsm) {
      Fimber.i('Register the transition $b -> $action -> $c');
    }

    final stateB = getOrBuildState(b)!;
    final stateC = getOrBuildState(c)!;
    stateB.onStream(stream, (WAction wa) {
      final isSameState = b == c;
      if (isSameState) {
        return;
      }

      if (C.debugFsm) {
        Fimber.i('Request transition $b -> $wa -> $c...');
      }

      if (action == wa.name) {
        stateC.enter();
        if (C.debugFsm) {
          Fimber.i('... accepted. The current state is `${current!.name}`.');
        }
      } else if (C.debugFsm) {
        Fimber.i('... rejected.');
      }
    });
  }

  void addCallbacks(String s, {Callback0? onEntry, Callback0? onExit}) {
    assert(s.isNotEmpty);
    assert(onEntry != null || onExit != null);

    final state = getOrBuildState(s);
    if (onEntry != null) {
      state!.onEntry(onEntry);
    }
    if (onExit != null) {
      state!.onExit(onExit);
    }
  }

  void sendAction(WAction action) => controller.add(action);

  @override
  void stop() {
    controller.close();
    super.stop();
  }

  final _stateMap = <String, State>{};

  State? getOrBuildState(String name) {
    if (!_stateMap.containsKey(name)) {
      _stateMap[name] = newState(name);
    }
    return _stateMap[name];
  }
}
