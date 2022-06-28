import 'package:api_happiness/api_happiness.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Card;

import '../../something_wrong.dart';
import '../preview_card.dart';
import 'later_card_view.dart';
import 'picture_card_view.dart';
import 'welcome_card_view.dart';

// ignore: avoid_classes_with_only_static_members
class CardViewFactory {
  static Widget build(BuildContext context, PreviewCard previewCard) {
    if (previewCard.type == CardType.picture) {
      return PictureCardView(previewCard: previewCard);
    }

    if (previewCard.type == CardType.welcome) {
      return WelcomeCardView(previewCard: previewCard);
    }

    if (previewCard.type == CardType.later) {
      return LaterCardView(previewCard: previewCard);
    }

    Fimber.e("Can't detect a view factory for $previewCard.");
    return const SomethingWrong();
  }
}
