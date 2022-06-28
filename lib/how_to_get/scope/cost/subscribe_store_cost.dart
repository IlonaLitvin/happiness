import 'package:api_happiness/api_happiness.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../../../app_text.dart';
import '../../../bricks/button_brick.dart';
import '../../../cards/preview_card.dart';
import '../../../config.dart';
import '../../../purchase/purchase_bloc.dart';
import '../../../purchase/purchase_event.dart';
import '../../../purchase/purchase_state.dart';
import '../../how_to_get_bloc.dart';
import '../scope_type.dart';
import 'cost.dart';
import 'cost_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'subscribe_store_cost.g.dart';

@JsonSerializable(ignoreUnannotated: true, includeIfNull: false)
class SubscribeStoreCost extends Cost {
  const SubscribeStoreCost({
    required super.cardType,
    required super.cardId,
    required super.scopeType,
  }) : super(costType: CostType.subscribe_store);

  factory SubscribeStoreCost.fromJson(Map<String, dynamic> json) =>
      _$SubscribeStoreCostFromJson(json);

  // \todo Like separate template builder?
  factory SubscribeStoreCost.fromJsonWithCard(
    CardType cardType,
    String cardId,
    ScopeType scopeType,
    // ignore: avoid_unused_constructor_parameters
    Map<String, dynamic> json,
  ) =>
      SubscribeStoreCost(
        cardType: cardType,
        cardId: cardId,
        scopeType: scopeType,
      );

  @override
  String get textTitle => localization.subscribe_title;

  @override
  String get textButton => throw UnimplementedError;

  @override
  String get textWhenThisPreferred => localization.subscribe_monthly_also;

  String get textGuaranteeCancel => C.purchase.isSubscriptionAutoRenewing
      ? localization.subscribe_guaranty_cancel_for_auto_renewing
      : localization.subscribe_guaranty_cancel_for_non_renewing;

  String get textButtonAnnual => localization.subscribe_annual_button;

  String get textButtonMonthly => localization.subscribe_monthly_button;

  String get textButtonRestore => localization.restore_purchases_button;

  String get textNoteRestore => localization.restore_purchases_note;

  @override
  Widget buildView(BuildContext context, PreviewCard previewCard) {
    assert(previewCard.id == cardId);

    final purchaseBloc = context.read<PurchaseBloc>();
    final purchaseState = purchaseBloc.state;
    if (C.debugPurchase) {
      Fimber.i('PurchaseBloc state $purchaseState');
    }

    if (purchaseState is AlreadyProAccessPurchaseState ||
        purchaseState is SuccessRestoredPurchaseState ||
        purchaseState is SuccessSubscribedPurchaseState) {
      onPressSendCompleted(context);
    }

    return _viewScreen(context);
  }

  Widget _viewScreen(BuildContext context) {
    final purchaseOrMonthly = [
      AppText(localization.text_or),
      ButtonBrick(
        text: textButtonMonthly,
        hasChildProtection: true,
        onPress: () => onPressForSubscribe(
          context,
          C.purchase.productIdSubscribeMonthly,
        ),
      ),
    ];
    final purchaseProLine = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonBrick(
          text: textButtonAnnual,
          hasChildProtection: true,
          onPress: () => onPressForSubscribe(
            context,
            C.purchase.productIdSubscribeAnnual,
          ),
        ),
        // \TODO On the iOS we catch error: Invalid product identifiers & Couldn't find SKUProduct for `hp.199.1m`.
        if (!C.isApple) ...purchaseOrMonthly,
      ],
    );

    final recoveryProLine = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(textNoteRestore),
        ButtonBrick(
          text: textButtonRestore,
          hasChildProtection: true,
          scale: 0.8,
          onPress: () => onPressForRestore(context),
        ),
      ],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(textTitle),
        purchaseProLine,
        AppText(textGuaranteeCancel),
        recoveryProLine,
      ],
    );
  }

  void onPressForSubscribe(BuildContext context, String productId) {
    Fimber.i('Purchase product `$productId`');

    final purchaseBloc = context.read<PurchaseBloc>();
    final htgBloc = context.read<HowToGetBloc>();
    purchaseBloc.add(PrepareBuySubscribePurchaseEvent(
      htgBloc: htgBloc,
      productId: productId,
      buyAfterInit: true,
    ));
  }

  void onPressForRestore(BuildContext context) {
    Fimber.i('Restore purchased');

    final purchaseBloc = context.read<PurchaseBloc>();
    final htgBloc = context.read<HowToGetBloc>();
    purchaseBloc.add(RestorePurchasesPurchaseEvent(htgBloc: htgBloc));
  }

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$SubscribeStoreCostToJson(this));
}
