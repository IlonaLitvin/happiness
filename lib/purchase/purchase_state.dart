import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object?> get props => [];
}

class NeedInitPurchaseState extends PurchaseState {
  const NeedInitPurchaseState();
}

abstract class WaitingPurchaseState extends PurchaseState {
  const WaitingPurchaseState();
}

class InitializingPurchaseState extends WaitingPurchaseState {
  const InitializingPurchaseState();
}

class ConnectingPurchaseState extends WaitingPurchaseState {
  const ConnectingPurchaseState();
}

class ReadyPurchaseState extends PurchaseState {
  const ReadyPurchaseState();
}

class SuccessPrepareBuyPurchaseState extends PurchaseState {
  final Package package;

  const SuccessPrepareBuyPurchaseState({required this.package});

  @override
  List<Object?> get props => [...super.props, package];
}

class UpdatedPurchaseState extends PurchaseState {
  final PurchaseState prevState;

  const UpdatedPurchaseState({required this.prevState});

  @override
  List<Object?> get props => [...super.props, prevState];
}

abstract class InfoPurchaseState extends PurchaseState {
  final String? productId;
  final PurchaserInfo? purchaserInfo;

  const InfoPurchaseState({
    required this.productId,
    required this.purchaserInfo,
  }) : assert(productId == null || productId.length > 0);

  @override
  List<Object?> get props => [...super.props, productId, purchaserInfo];
}

class AlreadyProAccessPurchaseState extends InfoPurchaseState {
  const AlreadyProAccessPurchaseState({
    super.productId,
    super.purchaserInfo,
  });
}

class SuccessSubscribedPurchaseState extends InfoPurchaseState {
  const SuccessSubscribedPurchaseState({
    super.productId,
    super.purchaserInfo,
  });
}

class SuccessRestoredPurchaseState extends InfoPurchaseState {
  const SuccessRestoredPurchaseState({
    super.productId,
    super.purchaserInfo,
  });
}

class NotFoundSubscriptionPurchaseState extends InfoPurchaseState {
  const NotFoundSubscriptionPurchaseState({
    super.productId,
    super.purchaserInfo,
  });
}

class CanceledPurchaseState extends PurchaseState {
  final String productId;

  const CanceledPurchaseState({this.productId = ''});

  @override
  List<Object?> get props => [...super.props, productId];
}

class FailurePurchaseState extends PurchaseState {
  final String error;
  final dynamic details;

  const FailurePurchaseState({this.error = '', this.details});

  @override
  List<Object?> get props => [...super.props, error, details];
}
