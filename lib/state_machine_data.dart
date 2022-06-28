/// TODO Move to `api_happiness`.
import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';

import 'effects/weffect.dart';
import 'extensions/weffect_extension.dart';
import 'welements/welement.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
//part 'state_machine_data.g.dart';

@immutable
class StateMachineData {
  final List<WTransition> transitionList;
  final List<WDirector> directorList;

  const StateMachineData({
    List<WTransition> transitions = const <WTransition>[],
    List<WDirector> directors = const <WDirector>[],
  })  : transitionList = transitions,
        directorList = directors;

  factory StateMachineData.fromString(String s) =>
      StateMachineData.fromJson(s.jsonMap);

  factory StateMachineData.fromJson(Map<String, dynamic> json) {
    final tl = (json['transitions'] ?? <dynamic>[]) as List<dynamic>;
    final transitions =
        tl.map((dynamic s) => WTransition.fromJson(s as String)).toList();

    final dl =
        (json['directors'] ?? <String, dynamic>{}) as Map<String, dynamic>;
    final directors = <WDirector>[];
    for (final state in dl.keys) {
      final e = <String, dynamic>{state: dl[state]};
      directors.add(WDirector.fromJson(e));
    }

    return StateMachineData(transitions: transitions, directors: directors);
  }

  Map<String, dynamic> toJson() {
    final r = <String, dynamic>{};
    if (transitionList.isNotEmpty) {
      r['transitions'] = transitionList.map((e) => e.toJson()).toList();
    }

    if (directorList.isNotEmpty) {
      r['directors'] = <String, dynamic>{};
      for (final director in directorList) {
        final effects = director.effectList
            .map((e) => <String, dynamic>{
                  e.name: e.toJson(),
                })
            .toList();
        final directors = r['directors'] as Map<String, dynamic>;
        directors[director.stateName] = effects;
      }
    }

    return r;
  }

  @override
  String toString() => toJson().sjson;

  @override
  bool operator ==(Object other) =>
      (other is StateMachineData) &&
      listEquals(transitionList, other.transitionList) &&
      listEquals(directorList, other.directorList);

  @override
  int get hashCode => toJson().hashCode;
}

@immutable
class WTransition {
  static const String separator = ' -> ';

  final String from;
  final String action;
  final String to;

  const WTransition(
    this.from,
    this.action,
    this.to,
  )   : assert(from.length > 0),
        assert(action.length > 0),
        assert(to.length > 0);

  factory WTransition.fromString(String s) => WTransition.fromJson(s);

  factory WTransition.fromJson(String json) {
    final l = json.split(separator);
    if (l.length != 3) {
      Fimber.e('The transitions should be contains 3 parts'
          ' separated by `$separator`. Actual: ${l.length}');
      return WTransition('', '', '');
    }

    final from = l[0].trim();
    final action = l[1].trim();
    final to = l[2].trim();
    return WTransition(from, action, to);
  }

  String toJson() {
    return [from, action, to].join(separator);
  }

  @override
  String toString() => toJson();

  @override
  bool operator ==(Object other) =>
      (other is WTransition) &&
      from == other.from &&
      action == other.action &&
      to == other.to;

  @override
  int get hashCode => [from, action, to].hashCode;
}

@immutable
class WDirector {
  final String stateName;
  final List<WEffect> effectList;

  const WDirector(
    this.stateName,
    this.effectList,
  ) : assert(stateName.length > 0);

  void runAll(Welement we) {
    for (final effect in effectList) {
      effect.run(we);
    }
  }

  factory WDirector.fromString(String s) => WDirector.fromJson(s.jsonMap);

  factory WDirector.fromJson(Map<String, dynamic> json) {
    final stateName = json.keys.first.trim();
    final el = (json[stateName] ?? <dynamic>[]) as List<dynamic>;
    final effects =
        el.map((dynamic e) => (e as Map<String, dynamic>).buildEffect).toList();

    return WDirector(stateName, effects);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        stateName: effectList
            .map((e) => <String, dynamic>{
                  e.name: e.toJson(),
                })
            .toList(),
      };

  @override
  String toString() => toJson().sjson;

  @override
  bool operator ==(Object other) =>
      (other is WDirector) &&
      stateName == other.stateName &&
      listEquals(effectList, other.effectList);

  @override
  int get hashCode => toJson().hashCode;
}

class WActions {
  static const String onEnd = 'OnEnd';
  static const String onTap = 'OnTap';
}

@immutable
abstract class WAction {
  final String name;

  const WAction(this.name) : assert(name.length > 0);

  @override
  bool operator ==(Object other) => (other is WAction) && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

/// An animation is action also.
class OnEndAction extends WAction {
  const OnEndAction() : super(WActions.onEnd);
}

class OnTapAction extends WAction {
  const OnTapAction() : super(WActions.onTap);
}
