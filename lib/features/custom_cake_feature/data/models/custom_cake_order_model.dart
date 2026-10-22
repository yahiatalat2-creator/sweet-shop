import 'package:flutter/material.dart';

import 'cake_option_model.dart';

enum CustomOrderStatus { pending, preparing, ready, delivered, cancelled }

enum FulfillmentType { pickup, delivery }

@immutable
class CustomCakeOrder {
  const CustomCakeOrder({
    required this.id,
    required this.size,
    required this.flavor,
    required this.design,
    required this.message,
    required this.fulfillment,
    required this.date,
    required this.timeSlot,
    required this.createdAt,
    this.address,
    this.status = CustomOrderStatus.pending,
  });

  final String id;
  final CakeOption size;
  final CakeOption flavor;
  final CakeOption design;

  /// Text written on the cake, e.g. "Happy Birthday". Can be empty.
  final String message;
  final FulfillmentType fulfillment;

  /// Pickup / delivery address (only used for delivery).
  final String? address;

  /// Pickup / delivery day.
  final DateTime date;
  final String timeSlot;
  final DateTime createdAt;
  final CustomOrderStatus status;

  bool get isDelivery => fulfillment == FulfillmentType.delivery;

  bool get isActive =>
      status == CustomOrderStatus.pending ||
      status == CustomOrderStatus.preparing ||
      status == CustomOrderStatus.ready;

  bool get canCancel => status == CustomOrderStatus.pending;

  double get cakePrice => size.price;
  double get flavorExtra => flavor.price;
  double get designExtra => design.price;
  double get deliveryFee => isDelivery ? CakeOptions.deliveryFee : 0;
  double get total => cakePrice + flavorExtra + designExtra + deliveryFee;

  String get statusLabel {
    switch (status) {
      case CustomOrderStatus.pending:
        return 'Pending';
      case CustomOrderStatus.preparing:
        return 'Preparing';
      case CustomOrderStatus.ready:
        return isDelivery ? 'Out for delivery' : 'Ready for pickup';
      case CustomOrderStatus.delivered:
        return isDelivery ? 'Delivered' : 'Picked up';
      case CustomOrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  CustomCakeOrder copyWith({final CustomOrderStatus? status}) {
    return CustomCakeOrder(
      id: id,
      size: size,
      flavor: flavor,
      design: design,
      message: message,
      fulfillment: fulfillment,
      address: address,
      date: date,
      timeSlot: timeSlot,
      createdAt: createdAt,
      status: status ?? this.status,
    );
  }
}
