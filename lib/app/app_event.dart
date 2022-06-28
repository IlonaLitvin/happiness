import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class InitAppEvent extends AppEvent {
  const InitAppEvent();
}

class ConnectToFirebaseAppEvent extends AppEvent {
  const ConnectToFirebaseAppEvent();
}
