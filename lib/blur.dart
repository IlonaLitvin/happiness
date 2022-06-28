import 'dart:ui' show ImageFilter;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart' hide Animation;

class StaticBlur extends StatelessWidget {
  final double sigma;

  const StaticBlur({super.key, required this.sigma});

  @override
  Widget build(BuildContext context) =>
      AnimatedBlur(startSigma: sigma, endSigma: sigma);
}

@immutable
class AnimatedBlur extends StatefulWidget {
  final double startSigma;
  final double endSigma;
  final Duration duration;

  const AnimatedBlur({
    super.key,
    required this.startSigma,
    required this.endSigma,
    this.duration = const Duration(seconds: 1),
  });

  @override
  // \todo Doesn't ignore `no_logic_in_create_state`.
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _AnimatedBlurState createState() => _AnimatedBlurState(
        startSigma: startSigma,
        endSigma: endSigma,
        duration: duration,
      );
}

class _AnimatedBlurState extends State<AnimatedBlur>
    with TickerProviderStateMixin {
  final double startSigma;
  final double endSigma;
  final Duration duration;

  late AnimationController controller;
  late Animation<double> sigma;

  _AnimatedBlurState({
    required this.startSigma,
    required this.endSigma,
    required this.duration,
  });

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    final Animation<double> curve =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    sigma = Tween<double>(
      begin: startSigma,
      end: endSigma,
    ).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    controller.forward().orCancel;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => sigma.value > 0
      ? Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma.value, sigmaY: sigma.value),
            child: Container(color: Colors.white.withOpacity(0)),
          ),
        )
      : Container();
}
