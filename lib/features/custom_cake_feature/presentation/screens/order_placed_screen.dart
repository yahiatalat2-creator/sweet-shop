import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/app_navigator.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_button.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/bordered_container.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';

import '../../data/models/custom_cake_order_model.dart';
import '../../utils/custom_cake_formatters.dart';
import '../widgets/cake_info_row.dart';
import 'my_custom_orders_screen.dart';

/// Shown after the order is confirmed and saved. Displays the Order ID.
class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key, required this.order});

  final CustomCakeOrder order;

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Order placed', showBackIcon: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: Dimens.extraLargePadding),
            Icon(Icons.check_circle, color: appColors.success, size: 84),
            const SizedBox(height: Dimens.largePadding),
            Text(
              'Your order is confirmed!',
              style: appTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: Dimens.padding),
            Text(
              'Order ID',
              style: appTypography.bodySmall.copyWith(color: appColors.gray4),
            ),
            Text(
              order.id,
              style: appTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: appColors.primary,
              ),
            ),
            const SizedBox(height: Dimens.veryLargePadding),
            BorderedContainer(
              padding: const EdgeInsets.all(Dimens.largePadding),
              child: Column(
                children: [
                  CakeInfoRow(
                    label: 'Cake',
                    value:
                        '${order.size.label} • ${order.flavor.label} • ${order.design.label}',
                  ),
                  if (order.message.isNotEmpty)
                    CakeInfoRow(label: 'Message', value: order.message),
                  CakeInfoRow(
                    label: order.isDelivery ? 'Delivery' : 'Pickup',
                    value: '${formatCakeDate(order.date)}\n${order.timeSlot}',
                  ),
                  CakeInfoRow(label: 'Status', value: order.statusLabel),
                  CakeInfoRow(
                    label: 'Total',
                    value: formatPrice(order.total),
                    bold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.largePadding,
            vertical: Dimens.padding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                title: 'View my orders',
                textStyle: appTypography.bodyLarge,
                borderRadius: Dimens.corners,
                margin: EdgeInsets.zero,
                onPressed: () {
                  appPushReplacement(context, const MyCustomOrdersScreen());
                },
              ),
              TextButton(
                onPressed: () => appPop(context),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
