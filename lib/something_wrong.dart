import 'package:flutter/material.dart' hide Card;

import 'active_localization.dart';
import 'app_text.dart';
import 'something_wrong_background.dart';

class SomethingWrong extends StatelessWidget with Localization {
  const SomethingWrong({super.key});

  @override
  Widget build(BuildContext context) => Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const SomethingWrongBackground(),
          AppText(localization.something_wrong_note),
        ],
      );
}
