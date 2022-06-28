import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../progress_widget.dart';
import '../../../something_wrong.dart';
import '../../active_localization.dart';
import '../../app_text.dart';
import '../../card_aware.dart';
import '../../how_to_get/how_to_get_page.dart';
import '../preview_card.dart';
import 'logic/card_bloc.dart';
import 'logic/card_event.dart';
import 'logic/card_state.dart';

class CardPage extends StatelessWidget with Localization {
  final PreviewCard previewCard;

  const CardPage({super.key, required this.previewCard});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => CardBloc(
          previewCard: previewCard,
          aware: CardAware(context),
        )..add(const CheckingCardEvent()),
        child: Builder(builder: _buildBlocBuilder),
      );

  Widget _buildBlocBuilder(BuildContext context) =>
      BlocBuilder<CardBloc, CardState>(builder: _build);

  Widget _build(BuildContext context, CardState state) {
    Fimber.i('build with CardState $state');

    if (state is CheckingCardState) {
      return ProgressWidget(children: AppText(localization.text_checking));
    }

    if (state is DownloadingCardState) {
      return ProgressWidget(children: AppText(localization.text_downloading));
    }

    if (state is ReadyToShowCardState) {
      return HowToGetPage(previewCard: previewCard);
    }

    if (state is FailureCardState) {
      return const SomethingWrong();
    }

    // all other states
    return ProgressWidget.empty();
  }
}
