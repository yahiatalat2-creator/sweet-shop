part of 'custom_orders_cubit.dart';

@immutable
class CustomOrdersState {
  const CustomOrdersState({required this.orders});

  /// Newest order first.
  final List<CustomCakeOrder> orders;

  List<CustomCakeOrder> get activeOrders =>
      orders.where((final o) => o.isActive).toList();

  List<CustomCakeOrder> get completedOrders =>
      orders.where((final o) => o.status == CustomOrderStatus.delivered).toList();

  List<CustomCakeOrder> get cancelledOrders =>
      orders.where((final o) => o.status == CustomOrderStatus.cancelled).toList();

  CustomCakeOrder? byId(final String id) {
    for (final order in orders) {
      if (order.id == id) return order;
    }
    return null;
  }
}
