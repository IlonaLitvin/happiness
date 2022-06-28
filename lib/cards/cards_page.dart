import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config.dart';
import 'cards_bloc.dart';
import 'cards_event.dart';
import 'cards_view.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: C.defaultFontSizeRelative,
        );

    return BlocProvider(
      create: (_) => CardsBloc()..add(const LoadingCardsEvent()),
      child: DefaultTextStyle(
        style: style,
        textAlign: TextAlign.center,
        child: const CardsView(),
      ),
    );
  }
}
