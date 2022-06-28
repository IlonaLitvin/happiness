import 'package:flutter/material.dart';

import 'blur.dart';
import 'card_aware.dart';
import 'config.dart';
import 'heart_blur_out_background.dart';

/* \todo https://github.com/JordanADavies/liquid_progress_indicator
class DownloadProgress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      DownloadProgressState();
}

class DownloadProgressState extends State<DownloadProgress> {
  double percent = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = percent * 100;
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: LiquidCircularProgressIndicator(
          value: percent,
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation(Colors.blue),
          center: AppText(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
*/

@immutable
class ProgressWidget extends StatelessWidget {
  static const List<Color> rainbowColors = [
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.purpleAccent,
  ];

  Color get color => Colors.yellowAccent;

  //Color get color => Utils.randomColor(rainbowColors);

  final Widget? children;

  const ProgressWidget({super.key, required this.children});

  factory ProgressWidget.empty() => ProgressWidget(children: Container());

  @override
  Widget build(BuildContext context) => Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const HeartBlurOutBackground(),
          _buildLoadingIndicator(CardAware(context).screenSize().x / 12),
          if (children != null) children!,
          const AnimatedBlur(
            startSigma: C.fastAnimatedBlurSigma / 2,
            endSigma: 0,
            duration: C.fastAnimatedBlurDuration,
          ),
        ],
      );

  Widget _buildLoadingIndicator(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: FractionallySizedBox(
          widthFactor: 0.4,
          heightFactor: 0.4,
          child: _loadingIndicatorSolid,
        ),
      );

  Widget get _loadingIndicatorSolid => CircularProgressIndicator(color: color);
}
