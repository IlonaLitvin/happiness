// \thanks https://youtu.be/h-jOMh2KXTA

import 'dart:async';

import 'package:dart_helpers/dart_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../config.dart';
import '../how_to_get/how_to_get_bloc.dart';
import '../how_to_get/how_to_get_event.dart';
import 'purchase_event.dart';
import 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  PurchaseBloc() : super(const NeedInitPurchaseState()) {
    if (C.debugBloc) {
      Fimber.i('PurchaseBloc start');
    }

    on<InitPurchaseEvent>(_onInit);
    on<PrepareBuySubscribePurchaseEvent>(_onPrepareBuySubscribe);
    on<BuyingSubscribePurchaseEvent>(_onBuySubscribe);
    on<RestorePurchasesPurchaseEvent>(_onRestorePurchases);
  }

  Future<void> _onInit(
    InitPurchaseEvent event,
    Emitter<PurchaseState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    emit(const InitializingPurchaseState());

    await pause();

    try {
      await Purchases.setDebugLogsEnabled(C.debugPurchase);
      await Purchases.setup(C.purchase.publicAppKey);
    } catch (ex) {
      emit(FailurePurchaseState(error: ex.toString()));
      return;
    }

    emit(const ReadyPurchaseState());

    await _verifySubscribe(emit);
  }

  Future<void> _verifySubscribe(Emitter<PurchaseState> emit) async {
    if (C.debugBloc) {
      Fimber.i('Start verifySubscribe()');
    }

    await pause();

    if (state is! ReadyPurchaseState) {
      await _onInit(const InitPurchaseEvent(), emit);
      if (state is! ReadyPurchaseState) {
        emit(const FailurePurchaseState(
          error: "Can't initialize the purchases.",
        ));
        return;
      }
    }

    late final PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
    } catch (ex) {
      emit(FailurePurchaseState(error: ex.toString()));
      return;
    }

    if (C.debugPurchase) {
      Fimber.i('purchaserInfo.entitlements ${purchaserInfo.entitlements}');
    }

    final entitlementId = C.purchase.entitlementPro;
    final isPro = purchaserInfo.entitlements.active.containsKey(entitlementId);
    if (C.debugPurchase) {
      Fimber.i('entitlementId `$entitlementId` isPro $isPro');
    }
    if (isPro) {
      emit(AlreadyProAccessPurchaseState(
        productId: entitlementId,
        purchaserInfo: purchaserInfo,
      ));
      return;
    }
  }

  void _onPrepareBuySubscribe(
    PrepareBuySubscribePurchaseEvent event,
    Emitter<PurchaseState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    await pause();

    await _verifySubscribe(emit);

    if (state is AlreadyProAccessPurchaseState ||
        state is FailurePurchaseState) {
      return;
    }

    late Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
    } catch (ex) {
      emit(FailurePurchaseState(error: ex.toString()));
      return;
    }

    final offering = offerings.current;
    if (C.debugPurchase) {
      Fimber.i('offering current $offering');
    }
    if (offering == null) {
      emit(FailurePurchaseState(
        error: "Can't detect a current offering.",
        details: offerings,
      ));
      return;
    }

    final Package? package;
    if (event.productId == C.purchase.productIdSubscribeAnnual) {
      package = offering.annual;
    } else if (event.productId == C.purchase.productIdSubscribeMonthly) {
      package = offering.monthly;
    } else {
      emit(FailurePurchaseState(
        error: "Can't recognize an offering for productId.",
        details: event.productId,
      ));
      return;
    }

    if (C.debugPurchase) {
      Fimber.i('offering package $package');
    }
    if (package == null) {
      emit(FailurePurchaseState(
        error: "Can't detect an offering package for productId.",
        details: event.productId,
      ));
      return;
    }

    emit(SuccessPrepareBuyPurchaseState(package: package));

    if (event.buyAfterInit) {
      add(BuyingSubscribePurchaseEvent(
        htgBloc: event.htgBloc,
        package: package,
      ));
    }
  }

  void _onBuySubscribe(
    BuyingSubscribePurchaseEvent event,
    Emitter<PurchaseState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    await pause();

    final entitlementId = C.purchase.entitlementPro;
    try {
      final purchaserInfo = await Purchases.purchasePackage(event.package);
      final isPro =
          purchaserInfo.entitlements.all[entitlementId]?.isActive ?? false;
      if (isPro) {
        emit(SuccessSubscribedPurchaseState(
          productId: entitlementId,
          purchaserInfo: purchaserInfo,
        ));
        _updateHowToGetBloc(event.htgBloc);
        return;
      }
    } on PlatformException catch (ex) {
      // explain the exception: `PurchasesErrorHelper.getErrorCode(ex)`
      final code = PurchasesErrorHelper.getErrorCode(ex);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        emit(CanceledPurchaseState(productId: entitlementId));
        _updateHowToGetBloc(event.htgBloc);
        return;
      }

      emit(FailurePurchaseState(
        error: 'Failed during fetching purchase info.',
        details: ex,
      ));
    } catch (ex) {
      emit(FailurePurchaseState(error: ex.toString()));
      _updateHowToGetBloc(event.htgBloc);
      return;
    }

    emit(FailurePurchaseState(
      error: 'Something wrong while purchase package.',
      details: event.package,
    ));

    _updateHowToGetBloc(event.htgBloc);
  }

  void _onRestorePurchases(
    RestorePurchasesPurchaseEvent event,
    Emitter<PurchaseState> emit,
  ) async {
    if (C.debugBloc) {
      Fimber.i('Start with event $event');
    }

    await pause();

    final entitlementId = C.purchase.entitlementPro;
    try {
      final purchaserInfo = await Purchases.restoreTransactions();
      final isPro =
          purchaserInfo.entitlements.all[entitlementId]?.isActive ?? false;
      emit(isPro
          ? SuccessRestoredPurchaseState(
              productId: entitlementId, purchaserInfo: purchaserInfo)
          : NotFoundSubscriptionPurchaseState(
              productId: entitlementId, purchaserInfo: purchaserInfo));
    } on PlatformException catch (ex) {
      emit(FailurePurchaseState(
        error: 'Failed during restoring purchase info.',
        details: ex,
      ));
    } catch (ex) {
      emit(FailurePurchaseState(error: ex.toString()));
    }

    _updateHowToGetBloc(event.htgBloc);
  }

  void _updateHowToGetBloc(HowToGetBloc htgBloc) {
    // show message into the [HowToGetBloc]
    // \todo Can we do it simpler?
    htgBloc.add(UpdatedPurchasesHowToGetEvent(
      cardId: htgBloc.state.cardId,
      purchaseBloc: this,
    ));
  }

  @mustCallSuper
  @override
  Future<void> close() async {
    super.close();

    if (C.os.isAndroid) {
      Purchases.close();
    }
  }
}
