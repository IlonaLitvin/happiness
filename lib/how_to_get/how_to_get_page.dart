import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../active_localization.dart';
import '../app_toast.dart';
import '../cards/card/card_view_factory.dart';
import '../cards/preview_card.dart';
import '../purchase/purchase_state.dart';
import 'how_to_get_bloc.dart';
import 'how_to_get_state.dart';
import 'htg_view_factory.dart';

/// \see https://figma.com/file/F5SadaVdDs4gMCeeKh2Hf3/happiness
class HowToGetPage extends StatelessWidget with Localization {
  final PreviewCard previewCard;

  const HowToGetPage({super.key, required this.previewCard});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => HowToGetBloc(cardId: previewCard.id),
        child: Builder(builder: _buildBlocBuilder),
      );

  Widget _buildBlocBuilder(BuildContext context) =>
      BlocBuilder<HowToGetBloc, HowToGetState>(
        builder: _build,
      );

  Widget _build(BuildContext context, HowToGetState state) {
    if (previewCard.isFree || state is CompletedHowToGetState) {
      return CardViewFactory.build(context, previewCard);
    }

    if (state is ShowMessageHowToGetState) {
      Fimber.i('purchaseStateLikeString ${state.purchaseStateLikeString}');
      final s = localizeMessage(state.purchaseStateLikeString);
      if (s.isNotEmpty) {
        showAppToast(s);
      }
      // yes, falling down
    }

    // InitHowToGetState, ShowMessageHowToGetState
    return HtgViewFactory.build(context, previewCard);
  }

  /// We don't need all localized message by states.
  String localizeMessage(String s) =>
      <String, String>{
        const AlreadyProAccessPurchaseState().runtimeType.toString(): '',
        const CanceledPurchaseState().runtimeType.toString(): '',
        const FailurePurchaseState().runtimeType.toString():
            localization.state_FailurePurchaseState,
        const NotFoundSubscriptionPurchaseState().runtimeType.toString():
            localization.state_NotFoundSubscriptionPurchaseState,
        const SuccessRestoredPurchaseState().runtimeType.toString():
            localization.state_SuccessRestoredPurchaseState,
        const SuccessSubscribedPurchaseState().runtimeType.toString():
            localization.state_SuccessSubscribedPurchaseState,
      }[s] ??
      '';
}
