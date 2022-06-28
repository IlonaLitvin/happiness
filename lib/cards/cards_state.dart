import 'package:equatable/equatable.dart';

abstract class CardsState extends Equatable {
  const CardsState();

  @override
  List<Object?> get props => [];
}

class LoadingCardsState extends CardsState {
  const LoadingCardsState();
}

class SuccessCardsState extends CardsState {
  const SuccessCardsState();
}

/// Move to next page.
class NextCardsState extends CardsState {
  const NextCardsState();
}

class FailureCardsState extends CardsState {
  final dynamic message;

  const FailureCardsState({this.message}) : assert(message != null);

  @override
  List<Object?> get props => [...super.props, message];
}
