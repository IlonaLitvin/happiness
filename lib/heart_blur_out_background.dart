import 'package:flutter/material.dart' hide Card;

import '../../blur.dart';
import '../../config.dart';
import 'heart_background.dart';

@immutable
class HeartBlurOutBackground extends StatelessWidget {
  final double startSigma;
  final double endSigma;
  final Duration duration;

  const HeartBlurOutBackground({
    super.key,
    this.startSigma = C.longAnimatedBlurSigma,
    this.endSigma = C.smallSizeStayBlurSigma,
    this.duration = C.longAnimatedBlurDuration,
  });

  @override
  Widget build(BuildContext context) => Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const HeartBackground(),
          AnimatedBlur(
            startSigma: startSigma,
            endSigma: endSigma,
            duration: duration,
          ),
        ],
      );
}
