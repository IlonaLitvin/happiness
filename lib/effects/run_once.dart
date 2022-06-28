/* \TODO
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';

import '../welements/welement.dart';

/// Call a function once and finish effect.
class RunOnce extends PositionComponentEffect {
  void Function(Welement?) code;

  RunOnce({
    required this.code,
    void Function()? onComplete,
  })  : super(false, true, modifiesSize: true, onComplete: onComplete);

  @override
  void setComponentToOriginalState() {
    super.setComponentToOriginalState();
    peakTime = 0.1;
  }

  bool _wasRunCode = false;

  @mustCallSuper
  @override
  void update(double dt) {
    super.update(dt);
    if (!_wasRunCode) {
      Fimber.i('Run code!');
      code(this as Welement);
      _wasRunCode = true;
      currentTime = peakTime = dt;
    }
  }
}
*/
