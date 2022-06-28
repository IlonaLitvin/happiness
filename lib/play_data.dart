import 'package:equatable/equatable.dart';

class PlayData extends Equatable implements Comparable<PlayData> {
  final int order;
  final String canvasName;
  final int bestScale;
  final String welementName;
  final String stateName;
  final double volume;

  const PlayData({
    this.order = -1,
    required this.canvasName,
    required this.bestScale,
    required this.welementName,
    required this.stateName,
    this.volume = 1.0,
  })  : assert(order == -1 || order > 0),
        assert(canvasName.length > 0),
        assert(bestScale > 0 && bestScale <= 100),
        assert(welementName.length > 0),
        assert(stateName.length > 0),
        assert(volume > 0);

  @override
  int compareTo(PlayData other) {
    return other.order - order;
  }

  @override
  List<Object?> get props => [
        order,
        canvasName,
        bestScale,
        welementName,
        stateName,
        volume,
      ];
}
