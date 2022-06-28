import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../how_to_get/how_to_get_bloc.dart';

abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object?> get props => [];
}

class InitPurchaseEvent extends PurchaseEvent {
  const InitPurchaseEvent();
}

class PrepareBuySubscribePurchaseEvent extends PurchaseEvent {
  final HowToGetBloc htgBloc;
  final String productId;
  final bool buyAfterInit;

  const PrepareBuySubscribePurchaseEvent({
    required this.htgBloc,
    required this.productId,
    this.buyAfterInit = false,
  }) : assert(productId.length > 0);

  @override
  List<Object?> get props => [...super.props, productId, buyAfterInit];
}

class BuyingSubscribePurchaseEvent extends PurchaseEvent {
  final HowToGetBloc htgBloc;
  final Package package;

  const BuyingSubscribePurchaseEvent({
    required this.htgBloc,
    required this.package,
  });

  @override
  List<Object?> get props => [...super.props, package];
}

class RestorePurchasesPurchaseEvent extends PurchaseEvent {
  final HowToGetBloc htgBloc;

  const RestorePurchasesPurchaseEvent({required this.htgBloc});
}
