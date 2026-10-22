import 'package:flutter/material.dart';

import '../data/models/custom_cake_order_model.dart';

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const List<String> _weekdays = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// e.g. "Sat, 25 Oct 2026"
String formatCakeDate(final DateTime date) {
  return '${_weekdays[date.weekday - 1]}, ${date.day} '
      '${_months[date.month - 1]} ${date.year}';
}

/// e.g. "$ 48.00"
String formatPrice(final double value) => '\$ ${value.toStringAsFixed(2)}';

/// Colour used for the status badge of an order.
Color statusColor(final CustomOrderStatus status) {
  switch (status) {
    case CustomOrderStatus.pending:
      return const Color(0xFFF5A524);
    case CustomOrderStatus.preparing:
      return const Color(0xFF3B82F6);
    case CustomOrderStatus.ready:
      return const Color(0xFF8B5CF6);
    case CustomOrderStatus.delivered:
      return const Color(0xFF4CAF50);
    case CustomOrderStatus.cancelled:
      return const Color(0xFFFC3D3D);
  }
}
