import 'package:equatable/equatable.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object?> get props => [];
}

class CheckingCardEvent extends CardEvent {
  const CheckingCardEvent();
}

/// We can download any card.
class DownloadCardEvent extends CardEvent {
  const DownloadCardEvent();
}
