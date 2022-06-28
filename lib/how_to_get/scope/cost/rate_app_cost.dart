import 'package:api_happiness/api_happiness.dart';
import 'package:flutter/material.dart' hide Card;

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../../../app_text.dart';
import '../../../bricks/rate_brick.dart';
import '../../../cards/preview_card.dart';
import '../scope_type.dart';
import 'cost.dart';
import 'cost_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'rate_app_cost.g.dart';

@JsonSerializable(includeIfNull: false)
class RateAppCost extends Cost {
  const RateAppCost({
    required super.cardType,
    required super.cardId,
    required super.scopeType,
  }) : super(costType: CostType.rate_app);

  factory RateAppCost.fromJson(Map<String, dynamic> json) =>
      _$RateAppCostFromJson(json);

  // \todo Like separate template builder?
  factory RateAppCost.fromJsonWithCard(
    CardType cardType,
    String cardId,
    ScopeType scopeType,
    // ignore: avoid_unused_constructor_parameters
    Map<String, dynamic> json,
  ) =>
      RateAppCost(
        cardType: cardType,
        cardId: cardId,
        scopeType: scopeType,
      );

  @override
  String get textTitle => localization.rate_app_title;

  @override
  String get textButton => throw UnimplementedError;

  @override
  String get textWhenThisPreferred => localization.rate_app_also;

  @override
  Widget buildView(BuildContext context, PreviewCard previewCard) {
    assert(previewCard.id == cardId);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(textTitle),
        // \todo Extends with child protection and change state to `completed` as done in `LinkBrick`.
        const RateBrick(),
      ],
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$RateAppCostToJson(this));
}
