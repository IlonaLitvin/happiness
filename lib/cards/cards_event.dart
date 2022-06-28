import 'package:equatable/equatable.dart';

abstract class CardsEvent extends Equatable {
  const CardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadingCardsEvent extends CardsEvent {
  const LoadingCardsEvent();
}

class NextCardsEvent extends CardsEvent {
  const NextCardsEvent();
}
