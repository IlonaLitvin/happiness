import 'package:api_happiness/api_happiness.dart';
import 'package:flutter/material.dart' hide Card;

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import '../../../bricks/button_brick.dart';
import '../../../cards/image_card_preview.dart';
import '../../../cards/preview_card.dart';
import '../../../config.dart';
import '../scope_type.dart';
import 'cost.dart';
import 'cost_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'get_free_cost.g.dart';

@JsonSerializable(includeIfNull: false)
class GetFreeCost extends Cost {
  const GetFreeCost({
    required super.cardType,
    required super.cardId,
    required super.scopeType,
  }) : super(costType: CostType.get_free);

  factory GetFreeCost.fromJson(Map<String, dynamic> json) =>
      _$GetFreeCostFromJson(json);

  // \todo Like separate template builder?
  factory GetFreeCost.fromJsonWithCard(
    CardType cardType,
    String cardId,
    ScopeType scopeType,
    // ignore: avoid_unused_constructor_parameters
    Map<String, dynamic> json,
  ) =>
      GetFreeCost(
        cardType: cardType,
        cardId: cardId,
        scopeType: scopeType,
      );

  @override
  String get textTitle => localization.just_get_picture;

  @override
  String get textButton => throw UnimplementedError;

  @override
  String get textWhenThisPreferred => '';

  @override
  Widget buildView(BuildContext context, PreviewCard previewCard) {
    assert(previewCard.id == cardId);

    // \todo Detect all CardType's.
    //final pictureCard = card as PictureCard;

    final previewSize = (C.defaultFontSizeRelative * 8).round();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonBrick(
          text: textTitle,
          hasChildProtection: false,
          onPress: () => onPressSendCompleted(context),
        ),
        C.delimiterWidget,
        ImageCardPreview(
          previewCard: previewCard,
          // \todo topChild: AutoSizeText('"${pictureCard.name}"', textAlign: TextAlign.center),
          width: previewSize,
          height: previewSize,
          onPressed: () => onPressSendCompleted(context),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..addAll(_$GetFreeCostToJson(this));
}
