import 'package:flutter/material.dart' hide Card;

import '../active_localization.dart';
import '../cards/preview_card.dart';

abstract class HtgView extends StatelessWidget with Localization {
  final PreviewCard previewCard;

  const HtgView({super.key, required this.previewCard});
}
