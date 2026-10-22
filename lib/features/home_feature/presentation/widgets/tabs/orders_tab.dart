import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/app_navigator.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/check_theme_status.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';

import '../../../../custom_cake_feature/presentation/screens/my_custom_orders_screen.dart';
import '../orders_list_widget.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    return AppScaffold(
      appBar: GeneralAppBar(
        title: 'My Orders',
        showBackIcon: false,
        actions: [
          IconButton(
            tooltip: 'Custom cake orders',
            icon: Icon(Icons.cake_outlined, color: appColors.primary),
            onPressed: () => appPush(context, const MyCustomOrdersScreen()),
          ),
          const SizedBox(width: 8),
        ],
        height: AppBar().preferredSize.height + 56,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: appColors.gray,
          labelColor: appColors.primary,
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          unselectedLabelColor:
              checkDarkMode(context) ? appColors.white : appColors.black,
          indicatorColor: appColors.primary,
          tabs: [
            Tab(child: Text('Active')),
            Tab(child: Text('Completed')),
            Tab(child: Text('Cancelled')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrdersListWidget(orderType: OrderType.active),
          OrdersListWidget(orderType: OrderType.completed),
          OrdersListWidget(orderType: OrderType.canceled),
        ],
      ),
    );
  }
}
