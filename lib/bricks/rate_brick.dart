import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import '../app_text.dart';
import '../child_protection.dart';
import '../config.dart';
import 'brick.dart';

/// Show a widget for rate App.
/// \see C.appStoreId
class RateBrick extends Brick {
  const RateBrick({
    super.key,
  });

  // ignore: avoid_unused_constructor_parameters
  factory RateBrick.fromJson(Map<String, dynamic> json) => const RateBrick();

  @override
  Widget build(BuildContext context) => ChildProtection(
        onCorrectTap: _launchRate,
        child: const AppText(' ⭐    ⭐   ⭐   ⭐  ⭐ '),
      );

  void _launchRate() async {
    Fimber.i('Launching a rate for App `${C.appStoreId}`...');
    InAppReview.instance.openStoreListing(appStoreId: C.appStoreId);
  }
}
