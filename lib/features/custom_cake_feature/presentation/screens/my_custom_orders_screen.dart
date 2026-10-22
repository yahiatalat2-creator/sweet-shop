import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/app_navigator.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/check_theme_status.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/bordered_container.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';

import '../../data/models/custom_cake_order_model.dart';
import '../../utils/custom_cake_formatters.dart';
import '../bloc/custom_orders_cubit.dart';
import '../widgets/order_status_badge.dart';
import 'custom_cake_screen.dart';
import 'custom_order_details_screen.dart';

/// "My Orders" page for custom cakes: lists the orders and their statuses.
class MyCustomOrdersScreen extends StatelessWidget {
  const MyCustomOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    return DefaultTabController(
      length: 3,
      child: AppScaffold(
        appBar: GeneralAppBar(
          title: 'My Custom Orders',
          height: AppBar().preferredSize.height + 56,
          bottom: TabBar(
            dividerColor: appColors.gray,
            labelColor: appColors.primary,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            unselectedLabelColor:
                checkDarkMode(context) ? appColors.white : appColors.black,
            indicatorColor: appColors.primary,
            tabs: const [
              Tab(child: Text('Active')),
              Tab(child: Text('Completed')),
              Tab(child: Text('Cancelled')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: appColors.primary,
          foregroundColor: Colors.white,
          onPressed: () => appPush(context, const CustomCakeScreen()),
          icon: const Icon(Icons.add),
          label: const Text('New cake'),
        ),
        body: BlocBuilder<CustomOrdersCubit, CustomOrdersState>(
          builder: (final context, final state) {
            return TabBarView(
              children: [
                _OrdersList(
                  orders: state.activeOrders,
                  emptyText: 'No active custom cake orders',
                ),
                _OrdersList(
                  orders: state.completedOrders,
                  emptyText: 'No completed orders yet',
                ),
                _OrdersList(
                  orders: state.cancelledOrders,
                  emptyText: 'No cancelled orders',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders, required this.emptyText});

  final List<CustomCakeOrder> orders;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cake_outlined, size: 64, color: appColors.gray2),
            const SizedBox(height: Dimens.largePadding),
            Text(
              emptyText,
              style: context.theme.appTypography.bodyMedium.copyWith(
                color: appColors.gray4,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(
        top: Dimens.largePadding,
        bottom: 96, // keeps the last card above the floating button
      ),
      itemCount: orders.length,
      separatorBuilder:
          (final context, final index) =>
              const SizedBox(height: Dimens.largePadding),
      itemBuilder: (final context, final index) {
        return _OrderCard(order: orders[index]);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final CustomCakeOrder order;

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;

    return BorderedContainer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.corners),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                () => appPush(
                  context,
                  CustomOrderDetailsScreen(orderId: order.id),
                ),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.id,
                        style: appTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      OrderStatusBadge(order: order),
                    ],
                  ),
                  const SizedBox(height: Dimens.padding),
                  Text(
                    '${order.size.label} • ${order.flavor.label} • ${order.design.label}',
                    style: appTypography.bodyMedium,
                  ),
                  if (order.message.isNotEmpty) ...[
                    const SizedBox(height: Dimens.smallPadding),
                    Text(
                      '"${order.message}"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appTypography.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: appColors.gray4,
                      ),
                    ),
                  ],
                  const SizedBox(height: Dimens.padding),
                  Row(
                    children: [
                      Icon(
                        order.isDelivery
                            ? Icons.delivery_dining_outlined
                            : Icons.storefront_outlined,
                        size: 16,
                        color: appColors.gray4,
                      ),
                      const SizedBox(width: Dimens.padding),
                      Expanded(
                        child: Text(
                          '${order.isDelivery ? 'Delivery' : 'Pickup'} • ${formatCakeDate(order.date)} • ${order.timeSlot}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appTypography.bodySmall.copyWith(
                            color: appColors.gray4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimens.mediumPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatPrice(order.total),
                        style: appTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: appColors.primary,
                        ),
                      ),
                      if (!order.isActive)
                        OutlinedButton(
                          onPressed:
                              () => appPush(
                                context,
                                CustomCakeScreen(reorderFrom: order),
                              ),
                          child: const Text('Order again'),
                        )
                      else
                        Text(
                          'Details',
                          style: appTypography.bodyMedium.copyWith(
                            color: appColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
