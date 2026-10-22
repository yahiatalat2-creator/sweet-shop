import 'package:flutter/material.dart';

/// One selectable choice in the cake builder (a size, a flavor or a design).
@immutable
class CakeOption {
  const CakeOption({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.price,
    required this.color,
    required this.icon,
  });

  final String id;
  final String label;
  final String subtitle;

  /// Base price for sizes, extra price for flavors and designs.
  final double price;
  final Color color;
  final IconData icon;
}

/// All the options that are available in the custom cake builder.
class CakeOptions {
  CakeOptions._();

  static const double deliveryFee = 5.0;

  /// A custom cake needs time to be prepared.
  static const int minLeadDays = 2;
  static const int maxAdvanceDays = 30;
  static const int maxMessageLength = 40;

  static const List<CakeOption> sizes = [
    CakeOption(
      id: 'small',
      label: 'Small',
      subtitle: '6" • serves 6-8',
      price: 25,
      color: Color(0xFFFB5650),
      icon: Icons.cake_outlined,
    ),
    CakeOption(
      id: 'medium',
      label: 'Medium',
      subtitle: '8" • serves 10-14',
      price: 40,
      color: Color(0xFFFB5650),
      icon: Icons.cake_outlined,
    ),
    CakeOption(
      id: 'large',
      label: 'Large',
      subtitle: '10" • serves 16-24',
      price: 60,
      color: Color(0xFFFB5650),
      icon: Icons.cake_outlined,
    ),
    CakeOption(
      id: 'xlarge',
      label: 'Extra large',
      subtitle: '12" • serves 25-35',
      price: 85,
      color: Color(0xFFFB5650),
      icon: Icons.cake_outlined,
    ),
  ];

  static const List<CakeOption> flavors = [
    CakeOption(
      id: 'vanilla',
      label: 'Vanilla',
      subtitle: 'Soft & creamy',
      price: 0,
      color: Color(0xFFF3E1B5),
      icon: Icons.icecream_outlined,
    ),
    CakeOption(
      id: 'chocolate',
      label: 'Chocolate',
      subtitle: 'Rich & dark',
      price: 0,
      color: Color(0xFF6B3E2A),
      icon: Icons.cookie_outlined,
    ),
    CakeOption(
      id: 'red_velvet',
      label: 'Red velvet',
      subtitle: 'Cream cheese',
      price: 4,
      color: Color(0xFFB3202D),
      icon: Icons.favorite_border,
    ),
    CakeOption(
      id: 'strawberry',
      label: 'Strawberry',
      subtitle: 'Fresh & fruity',
      price: 3,
      color: Color(0xFFF59AB0),
      icon: Icons.local_florist_outlined,
    ),
    CakeOption(
      id: 'lemon',
      label: 'Lemon',
      subtitle: 'Light & zesty',
      price: 3,
      color: Color(0xFFF6D860),
      icon: Icons.wb_sunny_outlined,
    ),
  ];

  static const List<CakeOption> designs = [
    CakeOption(
      id: 'classic',
      label: 'Classic',
      subtitle: 'Simple & elegant',
      price: 0,
      color: Color(0xFF9E9E9E),
      icon: Icons.auto_awesome_outlined,
    ),
    CakeOption(
      id: 'floral',
      label: 'Floral',
      subtitle: 'Sugar flowers',
      price: 8,
      color: Color(0xFFE75480),
      icon: Icons.local_florist,
    ),
    CakeOption(
      id: 'birthday',
      label: 'Birthday',
      subtitle: 'Candles & sprinkles',
      price: 6,
      color: Color(0xFFFF9800),
      icon: Icons.celebration_outlined,
    ),
    CakeOption(
      id: 'kids',
      label: 'Kids party',
      subtitle: 'Fun characters',
      price: 10,
      color: Color(0xFF2196F3),
      icon: Icons.toys_outlined,
    ),
    CakeOption(
      id: 'wedding',
      label: 'Wedding',
      subtitle: 'Tiered & fancy',
      price: 15,
      color: Color(0xFF7E57C2),
      icon: Icons.favorite,
    ),
  ];

  /// Pickup / delivery time slots offered by the shop.
  static const List<String> timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
  ];

  static CakeOption sizeById(final String id) =>
      sizes.firstWhere((final o) => o.id == id, orElse: () => sizes[1]);

  static CakeOption flavorById(final String id) =>
      flavors.firstWhere((final o) => o.id == id, orElse: () => flavors[0]);

  static CakeOption designById(final String id) =>
      designs.firstWhere((final o) => o.id == id, orElse: () => designs[0]);
}
