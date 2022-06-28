import 'package:api_happiness/api_happiness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config.dart';
import '../../bricks/brick_sequence.dart';
import '../../heart_blur_out_background.dart';
import '../cards_bloc.dart';
import '../cards_event.dart';
import '../preview_card.dart';

@immutable
class LaterCardView extends StatelessWidget {
  static const color = Colors.yellowAccent;
  static const colors = Colors.accents;

  final PreviewCard previewCard;

  const LaterCardView({super.key, required this.previewCard});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          final bloc = context.read<CardsBloc>();
          bloc.add(const NextCardsEvent());
        },
        child: _build(context),
      );

  Widget _build(BuildContext context) {
    final aboutCard = LaterAboutCard.fromJson(previewCard.aboutJson);

    final foreground = Center(
      child: Padding(
        padding: EdgeInsets.all(C.defaultFontSizeRelative * 2),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BrickSequence.fromJson(aboutCard.sequence),
        ),
      ),
    );

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [const HeartBlurOutBackground(), foreground],
    );
  }
}
