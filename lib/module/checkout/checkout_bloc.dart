import 'package:flutter/widgets.dart';
import 'package:app_storethuc/base/base_bloc.dart';
import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/data/repo/order_repo.dart';
import 'package:app_storethuc/event/confirm_order_event.dart';
import 'package:app_storethuc/event/pop_event.dart';
// ignore: unused_import
import 'package:app_storethuc/event/rebuild_event.dart';
import 'package:app_storethuc/event/update_cart_event.dart';
import 'package:app_storethuc/shared/model/order.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class CheckoutBloc extends BaseBloc with ChangeNotifier {
  final OrderRepo _orderRepo;

  CheckoutBloc({
    required OrderRepo orderRepo,
  }) : _orderRepo = orderRepo;

  final _orderSubject = BehaviorSubject<Order>();

  Stream<Order> get orderStream => _orderSubject.stream;
  Sink<Order> get orderSink => _orderSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case UpdateCartEvent:
        handleUpdateCart(event);
        break;
      case ConfirmOrderEvent:
        handleConfirmOrder(event);
        break;
    }
  }

  handleConfirmOrder(event) {
    _orderRepo.confirmOrder().then((isSuccess) {
      processEventSink.add(ShouldPopEvent());
    });
  }

  // handleUpdateCart(event) {
  //   UpdateCartEvent e = event as UpdateCartEvent;

  //   Observable.fromFuture(_orderRepo.updateOrder(e.product))
  //       .flatMap((_) => Observable.fromFuture(_orderRepo.getOrderDetail()))
  //       .listen((order) {
  //     orderSink.add(order);
  //   });
  // }
  void handleUpdateCart(event) {
    UpdateCartEvent e = event as UpdateCartEvent;
    Future<void>.microtask(() async {
      try {
        await _orderRepo.updateOrder(e.product);
        var order = await _orderRepo.getOrderDetail();
        orderSink.add(order);
      } catch (e) {
        // Handle any errors that occur during the update process
      }
    });
  }

  getOrderDetail() {
    Stream<Order>.fromFuture(
      _orderRepo.getOrderDetail(),
    ).listen((order) {
      orderSink.add(order);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // ignore: avoid_print
    print('checkout close');
    _orderSubject.close();
  }
}
