import 'package:flutter/material.dart' hide Card;

import '../how_to_get.dart';

abstract class ScopeView extends StatelessWidget {
  final HowToGet howToGet;

  const ScopeView({super.key, required this.howToGet});
}
