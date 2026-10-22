import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/app_navigator.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_button.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/bordered_container.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';

import '../../data/models/custom_cake_order_model.dart';
import '../../utils/custom_cake_formatters.dart';
import '../bloc/custom_orders_cubit.dart';
import '../widgets/cake_info_row.dart';
import '../widgets/cake_section_title.dart';
import '../widgets/order_status_badge.dart';
import 'custom_cake_screen.dart';

/// Order details: status, cake details, schedule, price and actions
/// (cancel a pending order / order again).
class CustomOrderDetailsScreen extends StatelessWidget {
  const CustomOrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomOrdersCubit, CustomOrdersState>(
      builder: (final context, final state) {
        final order = state.byId(orderId);
        if (order == null) {
          return AppScaffold(
            appBar: GeneralAppBar(title: 'Order details'),
            body: const Center(child: Text('Order not found')),
          );
        }
        return _DetailsView(order: order);
      },
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView({required this.order});

  final CustomCakeOrder order;

  Future<void> _confirmCancel(final BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (final dialogContext) => AlertDialog(
            title: const Text('Cancel order?'),
            content: Text('Order ${order.id} will be cancelled.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Keep order'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(
                  'Cancel order',
                  style: TextStyle(color: context.theme.appColors.error),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true && context.mounted) {
      context.read<CustomOrdersCubit>().cancelOrder(order.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;

    final steps = <String>[
      'Order placed',
      'Preparing',
      order.isDelivery ? 'Out for delivery' : 'Ready for pickup',
      order.isDelivery ? 'Delivered' : 'Picked up',
    ];
    final currentStep = order.status.index; // pending..delivered = 0..3

    return AppScaffold(
      appBar: GeneralAppBar(title: 'Order details'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimens.largePadding,
          children: [
            const SizedBox.shrink(),
            BorderedContainer(
              padding: const EdgeInsets.all(Dimens.largePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: appTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: Dimens.smallPadding),
                      Text(
                        'Placed on ${formatCakeDate(order.createdAt)}',
                        style: appTypography.bodySmall.copyWith(
                          color: appColors.gray4,
                        ),
                      ),
                    ],
                  ),
                  OrderStatusBadge(order: order),
                ],
              ),
            ),
            const CakeSectionTitle('Order status'),
            BorderedContainer(
              padding: const EdgeInsets.all(Dimens.largePadding),
              child:
                  order.status == CustomOrderStatus.cancelled
                      ? Row(
                        children: [
                          Icon(Icons.cancel_outlined, color: appColors.error),
                          const SizedBox(width: Dimens.mediumPadding),
                          Expanded(
                            child: Text(
                              'This order was cancelled.',
                              style: appTypography.bodyMedium,
                            ),
                          ),
                        ],
                      )
                      : Column(
                        children: List<Widget>.generate(steps.length, (
                          final index,
                        ) {
                          final reached = index <= currentStep;
                          final color =
                              reached ? appColors.primary : appColors.gray2;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    reached
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: color,
                                    size: 24,
                                  ),
                                  const SizedBox(width: Dimens.mediumPadding),
                                  Text(
                                    steps[index],
                                    style: appTypography.bodyMedium.copyWith(
                                      fontWeight:
                                          index == currentStep
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                      color: reached ? null : appColors.gray4,
                                    ),
                                  ),
                                ],
                              ),
                              if (index < steps.length - 1)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 11,
                                      top: 2,
                                      bottom: 2,
                                    ),
                                    width: 2,
                                    height: 14,
                                    color:
                                        index < currentStep
                                            ? appColors.primary
                                            : appColors.gray2,
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
            ),
            const CakeSectionTitle('Cake details'),
            BorderedContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.largePadding,
                vertical: Dimens.padding,
              ),
              child: Column(
                children: [
                  CakeInfoRow(label: 'Size', value: order.size.label),
                  CakeInfoRow(label: 'Flavor', value: order.flavor.label),
                  CakeInfoRow(label: 'Design', value: order.design.label),
                  CakeInfoRow(
                    label: 'Message',
                    value: order.message.isEmpty ? 'None' : order.message,
                  ),
                ],
              ),
            ),
            CakeSectionTitle(order.isDelivery ? 'Delivery' : 'Pickup'),
            BorderedContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.largePadding,
                vertical: Dimens.padding,
              ),
              child: Column(
                children: [
                  CakeInfoRow(label: 'Date', value: formatCakeDate(order.date)),
                  CakeInfoRow(label: 'Time', value: order.timeSlot),
                  if (order.isDelivery && (order.address ?? '').isNotEmpty)
                    CakeInfoRow(label: 'Address', value: order.address!),
                ],
              ),
            ),
            const CakeSectionTitle('Payment'),
            BorderedContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.largePadding,
                vertical: Dimens.padding,
              ),
              child: Column(
                children: [
                  CakeInfoRow(
                    label: '${order.size.label} cake',
                    value: formatPrice(order.cakePrice),
                  ),
                  CakeInfoRow(
                    label: '${order.flavor.label} flavor',
                    value: formatPrice(order.flavorExtra),
                  ),
                  CakeInfoRow(
                    label: '${order.design.label} design',
                    value: formatPrice(order.designExtra),
                  ),
                  if (order.isDelivery)
                    CakeInfoRow(
                      label: 'Delivery',
                      value: formatPrice(order.deliveryFee),
                    ),
                  const Divider(),
                  CakeInfoRow(
                    label: 'Total',
                    value: formatPrice(order.total),
                    bold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimens.largePadding),
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
          child: Row(
            children: [
              if (order.canCancel) ...[
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: appColors.error,
                        side: BorderSide(color: appColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.corners),
                        ),
                      ),
                      onPressed: () => _confirmCancel(context),
                      child: const Text('Cancel order'),
                    ),
                  ),
                ),
                const SizedBox(width: Dimens.mediumPadding),
              ],
              Expanded(
                child: AppButton(
                  title: 'Order again',
                  textStyle: appTypography.bodyLarge,
                  borderRadius: Dimens.corners,
                  margin: EdgeInsets.zero,
                  onPressed:
                      () => appPush(
                        context,
                        CustomCakeScreen(reorderFrom: order),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
