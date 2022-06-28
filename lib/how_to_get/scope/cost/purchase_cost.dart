import 'package:api_happiness/api_happiness.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Card;

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../../../app_text.dart';
import '../../../bricks/button_brick.dart';
import '../../../cards/preview_card.dart';
import '../scope_type.dart';
import 'cost.dart';
import 'cost_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'purchase_cost.g.dart';

@JsonSerializable(includeIfNull: false)
class PurchaseCost extends Cost {
  final double price;

  @JsonKey(ignore: true)
  bool get isFree => price <= 0.0;

  const PurchaseCost({
    required super.cardType,
    required super.cardId,
    required super.scopeType,
    required this.price,
  }) : super(costType: CostType.purchase);

  factory PurchaseCost.fromJson(Map<String, dynamic> json) =>
      _$PurchaseCostFromJson(json);

  // \todo Like separate template builder?
  factory PurchaseCost.fromJsonWithCard(
    CardType cardType,
    String cardId,
    ScopeType scopeType,
    Map<String, dynamic> json,
  ) =>
      PurchaseCost(
        cardType: cardType,
        cardId: cardId,
        scopeType: scopeType,
        price: (json['price'] ?? 0.0) as double,
      );

  @override
  String get textTitle => localization.purchase_title;

  @override
  String get textWhenThisPreferred => localization.purchase_also;

  @override
  String get textButton => localization.purchase_button_help;

  @override
  Widget buildView(BuildContext context, PreviewCard previewCard) {
    assert(previewCard.id == cardId);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(textTitle),
        ButtonBrick(
          text: textButton,
          hasChildProtection: true,
          onPress: () => _onPressForPurchase(context, previewCard),
        ),
      ],
    );
  }

  void _onPressForPurchase(
      BuildContext context, PreviewCard previewCard) async {
    Fimber.i('Purchase');

    throw UnimplementedError;
  }

  @override
  List<Object?> get props => [...super.props, price];

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$PurchaseCostToJson(this));
}
