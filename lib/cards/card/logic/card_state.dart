import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';

class CardState extends Equatable {
  const CardState();

  @override
  List<Object?> get props => [];
}

class InitCardState extends CardState {
  const InitCardState();
}

class CheckingCardState extends CardState {
  const CheckingCardState();
}

class DownloadingCardState extends CardState {
  const DownloadingCardState();
}

class ReadyToShowCardState extends CardState {
  const ReadyToShowCardState();
}

class FailureCardState extends CardState {
  final dynamic message;

  FailureCardState({this.message})
      : assert(message != null),
        assert((message is! String) || message.isNotEmpty,
            'The text message should be present.') {
    Fimber.e('Message from FailureCardState:', ex: message);
  }

  @override
  List<Object?> get props => [...super.props, message];
}
