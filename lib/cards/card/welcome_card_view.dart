import 'package:api_happiness/api_happiness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_helpers/flutter_helpers.dart';
import 'package:parallax_rain/parallax_rain.dart';

import '../../../app_text.dart';
import '../../../card_aware.dart';
import '../../../config.dart';
import '../../bricks/link_brick.dart';
import '../cards_bloc.dart';
import '../cards_event.dart';
import '../preview_card.dart';

@immutable
class WelcomeCardView extends StatelessWidget {
  static const color = Colors.yellowAccent;
  static const colors = Colors.accents;

  final PreviewCard previewCard;

  const WelcomeCardView({super.key, required this.previewCard});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          final bloc = context.read<CardsBloc>();
          bloc.add(const NextCardsEvent());
        },
        child: _build(context),
      );

  Widget _build(BuildContext context) {
    final top = Container();

    final dropWidth = C.defaultFontSizeRelative / 21;
    final dropHeight = C.defaultFontSizeRelative * 3 / 2;
    final rain = RotatedBox(
      quarterTurns: 2,
      child: ParallaxRain(
        numberOfDrops: 200,
        dropFallSpeed: 0.05,
        numberOfLayers: 3,
        dropWidth: dropWidth,
        dropHeight: dropHeight,
        dropColors: colors,
        trailStartFraction: 0.1,
        distanceBetweenLayers: 1,
        rainIsInBackground: true,
        trail: true,
      ),
    );

    final textStyle = C.bottomTextStyle;
    final maxFontSize = textStyle.fontSize ?? C.defaultBottomFontSizeRelative;
    final minFontSize = (maxFontSize / 2).roundToDouble();
    final padding = C.defaultBottomFontSizeRelative;

    final aboutCard = WelcomeAboutCard.fromJson(previewCard.aboutJson);

    Widget? privacy;
    if (aboutCard.privacy != null) {
      final widget = LinkBrick.fromJson(aboutCard.privacy!);
      privacy = Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: padding),
          child: widget.copyWith(
            style: textStyle,
            minFontSize: minFontSize,
            maxFontSize: maxFontSize,
            maxLines: 1,
          ),
        ),
      );
    }

    Widget? terms;
    if (aboutCard.terms != null) {
      final widget = LinkBrick.fromJson(aboutCard.terms!);
      terms = Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.bottomCenter,
        child: widget.copyWith(
          style: textStyle,
          minFontSize: minFontSize,
          maxFontSize: maxFontSize,
          maxLines: 1,
        ),
      );
    }

    final version = FutureBuilder<String>(
      future: appVersion,
      builder: (context, snapshot) => snapshot.hasData
          ? Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: padding),
                child: AppText(
                  snapshot.data ?? '',
                  textStyle: textStyle,
                  textAlign: TextAlign.right,
                  minFontSize: minFontSize,
                  maxFontSize: maxFontSize,
                  maxLines: 1,
                ),
              ),
            )
          : Container(),
    );

    final bottom = Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: padding / 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(child: privacy ?? Container()),
            Flexible(child: terms ?? Container()),
            Flexible(child: version),
          ],
        ),
      ),
    );

    final ss = CardAware(context).screenSize();
    final titleSize = ss.x / 12;
    final blurRadius = titleSize / 6;
    final foreground = Center(
      child: Column(
        children: [
          Expanded(flex: 1, child: top),
          Column(
            children: [
              if (aboutCard.title1.isNotEmpty)
                _glowText(
                  aboutCard.title1,
                  size: titleSize,
                  blurRadius: blurRadius,
                ),
              if (aboutCard.title2.isNotEmpty)
                _glowText(
                  aboutCard.title2,
                  size: titleSize / 2,
                  blurRadius: blurRadius,
                ),
              if (aboutCard.subtitle.isNotEmpty)
                _glowText(
                  aboutCard.subtitle,
                  size: titleSize / 3,
                  blurRadius: blurRadius / 3,
                ),
            ],
          ),
          Expanded(flex: 2, child: bottom),
        ],
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        rain,
        foreground,
      ],
    );
  }

  GlowText _glowText(
    String text, {
    required double size,
    required double blurRadius,
  }) =>
      GlowText(
        text,
        glowColor: color,
        blurRadius: blurRadius,
        offset: Offset.zero,
        style: TextStyle(
          fontSize: size,
          color: color,
        ),
      );
}
