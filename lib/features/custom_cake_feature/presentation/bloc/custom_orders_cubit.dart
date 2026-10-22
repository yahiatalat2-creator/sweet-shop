import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../data/models/cake_option_model.dart';
import '../../data/models/custom_cake_order_model.dart';

part 'custom_orders_state.dart';

/// Keeps the custom cake orders of the user (in memory, like the cart).
class CustomOrdersCubit extends Cubit<CustomOrdersState> {
  CustomOrdersCubit() : super(CustomOrdersState(orders: _sampleOrders()));

  // Sample orders use ids CK-1001..CK-1003, new orders continue from here.
  int _lastOrderNumber = 1003;

  /// Saves a confirmed order, generates its Order ID and returns it.
  CustomCakeOrder placeOrder({
    required final CakeOption size,
    required final CakeOption flavor,
    required final CakeOption design,
    required final String message,
    required final FulfillmentType fulfillment,
    required final DateTime date,
    required final String timeSlot,
    final String? address,
  }) {
    _lastOrderNumber++;
    final order = CustomCakeOrder(
      id: 'CK-$_lastOrderNumber',
      size: size,
      flavor: flavor,
      design: design,
      message: message.trim(),
      fulfillment: fulfillment,
      address:
          fulfillment == FulfillmentType.delivery ? address?.trim() : null,
      date: date,
      timeSlot: timeSlot,
      createdAt: DateTime.now(),
    );
    emit(CustomOrdersState(orders: [order, ...state.orders]));
    return order;
  }

  /// Only pending orders can be cancelled.
  void cancelOrder(final String id) {
    final updated =
        state.orders.map((final order) {
          if (order.id == id && order.canCancel) {
            return order.copyWith(status: CustomOrderStatus.cancelled);
          }
          return order;
        }).toList();
    emit(CustomOrdersState(orders: updated));
  }

  static List<CustomCakeOrder> _sampleOrders() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      CustomCakeOrder(
        id: 'CK-1003',
        size: CakeOptions.sizeById('medium'),
        flavor: CakeOptions.flavorById('red_velvet'),
        design: CakeOptions.designById('birthday'),
        message: 'Happy Birthday Sara',
        fulfillment: FulfillmentType.delivery,
        address: 'Montgomery Street Country Street East Pkwy',
        date: today.add(const Duration(days: 3)),
        timeSlot: '05:00 PM',
        createdAt: now.subtract(const Duration(hours: 5)),
        status: CustomOrderStatus.preparing,
      ),
      CustomCakeOrder(
        id: 'CK-1002',
        size: CakeOptions.sizeById('large'),
        flavor: CakeOptions.flavorById('chocolate'),
        design: CakeOptions.designById('classic'),
        message: 'Congratulations',
        fulfillment: FulfillmentType.pickup,
        date: today.subtract(const Duration(days: 12)),
        timeSlot: '02:00 PM',
        createdAt: today.subtract(const Duration(days: 16)),
        status: CustomOrderStatus.delivered,
      ),
      CustomCakeOrder(
        id: 'CK-1001',
        size: CakeOptions.sizeById('small'),
        flavor: CakeOptions.flavorById('strawberry'),
        design: CakeOptions.designById('floral'),
        message: '',
        fulfillment: FulfillmentType.pickup,
        date: today.subtract(const Duration(days: 30)),
        timeSlot: '11:00 AM',
        createdAt: today.subtract(const Duration(days: 35)),
        status: CustomOrderStatus.cancelled,
      ),
    ];
  }
}
