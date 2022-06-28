import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Card;

import '../cards/preview_card.dart';
import '../something_wrong.dart';
import 'htg_one_scope_any_costs_view.dart';

// ignore: avoid_classes_with_only_static_members
/// A factory that, using sets of scopes & costs, produces a suitable image
/// for demonstration to the Visitor.
/// \see ScopeType, CostType
class HtgViewFactory {
  static StatelessWidget build(BuildContext context, PreviewCard previewCard) {
    final scopes = previewCard.howToGet.scopes;
    if (scopes.length == 1) {
      final scope = scopes.first;
      final costs = scope.costs;
      if (costs.isNotEmpty) {
        return HtgOneScopeAnyCostsView(previewCard: previewCard);
      }
    }

    Fimber.e("Can't detect a view factory for HowToGet"
        ' with card $previewCard.');
    return const SomethingWrong();
  }
}
