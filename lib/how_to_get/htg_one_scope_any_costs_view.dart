import 'package:flutter/material.dart' hide Card;

import '../app_text.dart';
import '../config.dart';
import '../heart_background.dart';
import 'htg_view.dart';

class HtgOneScopeAnyCostsView extends HtgView {
  const HtgOneScopeAnyCostsView({super.key, required super.previewCard});

  @override
  Widget build(BuildContext context) {
    final scopes = previewCard.howToGet.scopes;
    final scope = scopes.first;
    final preferredCost = scope.costs.first;
    final preferredCostView = preferredCost.buildView(context, previewCard);

    final costs = scope.costs;
    final otherCostsViews = <Widget>[];
    if (costs.length > 1) {
      // \todo Work with many costs for scope.
      otherCostsViews.add(costs.last.buildView(context, previewCard));
    }

    final padding = C.defaultFontSizeRelative * 2;
    final content = SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: padding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          preferredCostView,
          C.delimiterWidget,
          AppText(preferredCost.textWhenThisPreferred),
          ...otherCostsViews,
        ],
      ),
    );

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        const HeartBackground(),
        content,
      ],
    );
  }
}
