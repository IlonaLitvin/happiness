import 'state_machine_data.dart';
import 'welements/welement.dart';

class EffectData implements Comparable<EffectData> {
  final WAction action;
  final Welement welement;

  int get order => welement.order;

  const EffectData({
    required this.action,
    required this.welement,
  });

  @override
  int compareTo(EffectData other) {
    return other.order - order;
  }

  @override
  String toString() => 'action $action for `${welement.name}`'
      ' with state `${welement.stateName}`';
}
