import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class InitAppState extends AppState {
  const InitAppState();
}

class SuccessConnectedToFirebaseAppState extends AppState {
  const SuccessConnectedToFirebaseAppState();
}

class FailureConnectedToFirebaseAppState extends AppState {
  const FailureConnectedToFirebaseAppState();
}
