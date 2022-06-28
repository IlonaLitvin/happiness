import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../progress_widget.dart';
import '../active_localization.dart';
import '../app_text.dart';
import '../audio_horn.dart';
import '../config.dart';
import '../service_locator.dart';
import '../something_wrong.dart';
import 'cards_bloc.dart';
import 'cards_item_view.dart';
import 'cards_state.dart';

class CardsView extends StatefulWidget {
  const CardsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardsViewState createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> with Localization {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CardsBloc, CardsState>(builder: _build);

  Widget _build(BuildContext context, CardsState state) {
    if (state is FailureCardsState) {
      return const SomethingWrong();
    }

    final bloc = context.read<CardsBloc>();

    if (state is SuccessCardsState || state is NextCardsState) {
      if (bloc.previewCards.isEmpty) {
        Fimber.e('No cards.');
        return const SomethingWrong();
      }

      if (state is NextCardsState) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInQuint,
        );
      }

      return PageView.builder(
        itemBuilder: (BuildContext context, int i) =>
            CardsItemView(previewCard: bloc.previewCards[i]),
        itemCount: bloc.previewCards.length,
        onPageChanged: (i) {
          if (C.debugBloc) {
            Fimber.i('onPageChanged() i $i');
          }
          sl.get<AudioHorn>().release();
        },
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
      );
    }

    // for LoadingCardsState
    return Center(
      child: ProgressWidget(
        children: AppText(localization.text_downloading),
      ),
    );
  }
}
