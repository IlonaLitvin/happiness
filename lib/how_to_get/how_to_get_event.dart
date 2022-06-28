import 'package:equatable/equatable.dart';

import '../purchase/purchase_bloc.dart';

abstract class HowToGetEvent extends Equatable {
  final String cardId;

  const HowToGetEvent({required this.cardId});

  @override
  List<Object?> get props => [cardId];
}

class CompletedHowToGetEvent extends HowToGetEvent {
  const CompletedHowToGetEvent({required super.cardId});
}

class UpdatedPurchasesHowToGetEvent extends HowToGetEvent {
  final PurchaseBloc purchaseBloc;

  const UpdatedPurchasesHowToGetEvent({
    required super.cardId,
    required this.purchaseBloc,
  });
}
