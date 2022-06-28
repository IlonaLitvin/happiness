import 'package:api_happiness/api_happiness.dart';
import 'package:flutter/material.dart' hide Card;

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../../../app_text.dart';
import '../../../bricks/link_brick.dart';
import '../../../cards/preview_card.dart';
import '../../../config.dart';
import '../scope_type.dart';
import 'cost.dart';
import 'cost_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'subscribe_telegram_cost.g.dart';

@JsonSerializable(includeIfNull: false)
class SubscribeTelegramCost extends Cost {
  const SubscribeTelegramCost({
    required super.cardType,
    required super.cardId,
    required super.scopeType,
  }) : super(costType: CostType.subscribe_telegram);

  factory SubscribeTelegramCost.fromJson(Map<String, dynamic> json) =>
      _$SubscribeTelegramCostFromJson(json);

  // \todo Like separate template builder?
  factory SubscribeTelegramCost.fromJsonWithCard(
    CardType cardType,
    String cardId,
    ScopeType scopeType,
    // ignore: avoid_unused_constructor_parameters
    Map<String, dynamic> json,
  ) =>
      SubscribeTelegramCost(
        cardType: cardType,
        cardId: cardId,
        scopeType: scopeType,
      );

  @override
  String get textTitle => localization.subscribe_telegram_title;

  @override
  String get textWhenThisPreferred => localization.subscribe_telegram_also;

  @override
  String get textButton => localization.subscribe_button;

  @override
  Widget buildView(BuildContext context, PreviewCard previewCard) {
    assert(previewCard.id == cardId);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          textTitle,
          textAlign: TextAlign.center,
          minFontSize: C.defaultFontSizeRelative,
          maxLines: 2,
        ),
        LinkBrick(
          text: textButton,
          link: C.telegramLink,
          hasChildProtection: true,
          likeButton: true,
          onPressCorrectAnswer: onPressSendCompleted,
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$SubscribeTelegramCostToJson(this));
}
