import 'package:fimber/fimber.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'blur.dart';
import 'cards/card/background_card_preview.dart';
import 'config.dart';
import 'picture_game.dart';
import 'picture_source.dart';
import 'something_wrong.dart';

@immutable
class Game extends StatelessWidget {
  final PictureSource source;
  final PictureGame game;
  final Widget background;

  Game({super.key, required this.source})
      : game = PictureGame.fromPictureSource(source: source),
        background = BackgroundCardPreview(cardId: source.id);

  @override
  Widget build(BuildContext context) {
    Fimber.i('Build Game');

    return Stack(
      children: [
        GameWidget(
          game: game,
          loadingBuilder: (context) => background,
          backgroundBuilder: (context) => background,
          errorBuilder: (context, error) {
            Fimber.e('Something wrong when build `GameWidget`.', ex: error);
            return const SomethingWrong();
          },
        ),
        const AnimatedBlur(
          startSigma: C.fastAnimatedBlurSigma,
          endSigma: 0,
          duration: C.fastAnimatedBlurDuration,
        ),
      ],
    );
  }
}
