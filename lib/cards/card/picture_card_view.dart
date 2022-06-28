import 'package:flutter/material.dart';

import '../../card_aware.dart';
import '../../game.dart';
import '../../picture_source.dart';
import '../preview_card.dart';

@immutable
class PictureCardView extends StatelessWidget {
  final PreviewCard previewCard;

  const PictureCardView({super.key, required this.previewCard});

  @override
  Widget build(BuildContext context) {
    final aware = CardAware(context);
    final pictureSource = PictureSource.fromPreviewCard(previewCard, aware);

    return FutureBuilder<PictureSource?>(
      future: pictureSource,
      builder: (context, snapshot) =>
          snapshot.hasData ? Game(source: snapshot.data!) : Container(),
    );
  }
}
