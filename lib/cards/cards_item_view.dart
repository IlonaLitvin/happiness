import 'package:flutter/material.dart' hide Card;

import 'card/card_page.dart';
import 'preview_card.dart';

class CardsItemView extends StatelessWidget {
  final PreviewCard previewCard;

  const CardsItemView({super.key, required this.previewCard});

  @override
  Widget build(BuildContext context) => Material(
        child: ClipRect(
          clipBehavior: Clip.antiAlias,
          child: CardPage(previewCard: previewCard),
        ),
      );
}
