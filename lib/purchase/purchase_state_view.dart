/*
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'purchase_bloc.dart';
import 'purchase_event.dart';
import 'purchase_state.dart';

class PurchaseStateView extends StatelessWidget {
  const PurchaseStateView();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (BuildContext context) =>
            PurchaseBloc()..add(const InitPurchaseEvent()),
        child: Builder(builder: _buildBlocBuilder),
      );

  Widget _buildBlocBuilder(BuildContext context) =>
      BlocBuilder<PurchaseBloc, PurchaseState>(
        builder: _build,
      );

  Widget _build(BuildContext context, PurchaseState state) {
    Fimber.i('bloc state is `$state`');

    if (state is InitializingPurchaseState ||
        state is NeedInitPurchaseState ||
        state is FailurePurchaseState ||
        state is ReadyPurchaseState) {
      return Container();
    }

    try {
      final scaffold = ScaffoldMessenger.of(context);
      if (scaffold.mounted) {
        final snack = SnackBar(content: Text(state.toString()));
        scaffold.showSnackBar(snack);
      }
    } catch (ex) {
      // \todo fine stable Fix it gently.
    }

    return Container();
  }
}
*/
