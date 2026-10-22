import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/app_navigator.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/check_theme_status.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_button.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_choice_chip.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/bordered_container.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';

import '../../data/models/cake_option_model.dart';
import '../../data/models/custom_cake_order_model.dart';
import '../../utils/custom_cake_formatters.dart';
import '../bloc/custom_orders_cubit.dart';
import '../widgets/cake_info_row.dart';
import '../widgets/cake_option_selector.dart';
import '../widgets/cake_preview_widget.dart';
import '../widgets/cake_section_title.dart';
import '../widgets/cake_text_field.dart';
import 'order_placed_screen.dart';

/// Custom cake builder: size, flavor, design, message, date/time and
/// pickup / delivery. Pass [reorderFrom] to start from a previous order.
class CustomCakeScreen extends StatefulWidget {
  const CustomCakeScreen({super.key, this.reorderFrom});

  final CustomCakeOrder? reorderFrom;

  @override
  State<CustomCakeScreen> createState() => _CustomCakeScreenState();
}

class _CustomCakeScreenState extends State<CustomCakeScreen> {
  static const List<String> _messageSuggestions = [
    'Happy Birthday',
    'Congratulations',
    'Happy Anniversary',
    'Best Wishes',
  ];

  late CakeOption _size;
  late CakeOption _flavor;
  late CakeOption _design;
  late FulfillmentType _fulfillment;
  DateTime? _date;
  String? _slot;
  bool _submitted = false;

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final previous = widget.reorderFrom;
    _size = previous?.size ?? CakeOptions.sizes[1];
    _flavor = previous?.flavor ?? CakeOptions.flavors[0];
    _design = previous?.design ?? CakeOptions.designs[0];
    _fulfillment = previous?.fulfillment ?? FulfillmentType.pickup;
    _messageController.text = previous?.message ?? '';
    _addressController.text = previous?.address ?? '';
    // The date and time are always chosen again for a new order.
  }

  @override
  void dispose() {
    _messageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool get _isDelivery => _fulfillment == FulfillmentType.delivery;

  double get _total =>
      _size.price +
      _flavor.price +
      _design.price +
      (_isDelivery ? CakeOptions.deliveryFee : 0);

  /// Simulated availability: some time slots are already booked on each day.
  bool _isSlotAvailable(final DateTime date, final int index) {
    return (date.day + index) % 5 != 0;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final first = today.add(const Duration(days: CakeOptions.minLeadDays));
    final last = today.add(const Duration(days: CakeOptions.maxAdvanceDays));

    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? first,
      firstDate: first,
      lastDate: last,
    );
    if (picked == null) return;

    setState(() {
      _date = picked;
      // Drop the chosen time if it is not available on the new day.
      final slot = _slot;
      if (slot != null &&
          !_isSlotAvailable(picked, CakeOptions.timeSlots.indexOf(slot))) {
        _slot = null;
      }
    });
  }

  void _onReview() {
    setState(() => _submitted = true);

    final addressMissing = _isDelivery && _addressController.text.trim().isEmpty;
    if (_date == null || _slot == null || addressMissing) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Please complete the required fields')),
        );
      return;
    }
    _showSummary();
  }

  void _showSummary() {
    final appTypography = context.theme.appTypography;
    final date = _date!;
    final slot = _slot!;
    final message = _messageController.text.trim();
    final address = _addressController.text.trim();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (final sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              Dimens.largePadding,
              0,
              Dimens.largePadding,
              Dimens.largePadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review your order',
                  style: appTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: Dimens.largePadding),
                CakeInfoRow(label: 'Size', value: _size.label),
                CakeInfoRow(label: 'Flavor', value: _flavor.label),
                CakeInfoRow(label: 'Design', value: _design.label),
                CakeInfoRow(
                  label: 'Message',
                  value: message.isEmpty ? 'None' : message,
                ),
                CakeInfoRow(
                  label: _isDelivery ? 'Delivery' : 'Pickup',
                  value: '${formatCakeDate(date)}\n$slot',
                ),
                if (_isDelivery) CakeInfoRow(label: 'Address', value: address),
                const Divider(height: Dimens.veryLargePadding),
                CakeInfoRow(
                  label: 'Total',
                  value: formatPrice(_total),
                  bold: true,
                ),
                const SizedBox(height: Dimens.largePadding),
                AppButton(
                  title: 'Confirm order',
                  textStyle: appTypography.bodyLarge,
                  borderRadius: Dimens.corners,
                  margin: EdgeInsets.zero,
                  onPressed: () {
                    final order = context.read<CustomOrdersCubit>().placeOrder(
                      size: _size,
                      flavor: _flavor,
                      design: _design,
                      message: message,
                      fulfillment: _fulfillment,
                      date: date,
                      timeSlot: slot,
                      address: address,
                    );
                    Navigator.pop(sheetContext);
                    appPushReplacement(context, OrderPlacedScreen(order: order));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    final isDark = checkDarkMode(context);
    final dateError = _submitted && _date == null;
    final slotError = _submitted && _date != null && _slot == null;
    final addressError =
        _submitted && _isDelivery && _addressController.text.trim().isEmpty;

    return AppScaffold(
      appBar: GeneralAppBar(
        title: widget.reorderFrom == null ? 'Custom Cake' : 'Order Again',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimens.largePadding,
          children: [
            const SizedBox.shrink(),
            CakePreviewWidget(
              size: _size,
              flavor: _flavor,
              design: _design,
              message: _messageController.text,
            ),
            const CakeSectionTitle('Size'),
            CakeOptionSelector(
              options: CakeOptions.sizes,
              selectedId: _size.id,
              showBasePrice: true,
              onSelected: (final option) => setState(() => _size = option),
            ),
            const CakeSectionTitle('Flavor'),
            CakeOptionSelector(
              options: CakeOptions.flavors,
              selectedId: _flavor.id,
              onSelected: (final option) => setState(() => _flavor = option),
            ),
            const CakeSectionTitle('Design'),
            CakeOptionSelector(
              options: CakeOptions.designs,
              selectedId: _design.id,
              onSelected: (final option) => setState(() => _design = option),
            ),
            const CakeSectionTitle('Message on the cake', trailing: 'Optional'),
            CakeTextField(
              controller: _messageController,
              hint: 'e.g. Happy Birthday',
              maxLength: CakeOptions.maxMessageLength,
              onChanged: (final _) => setState(() {}),
            ),
            Wrap(
              spacing: Dimens.padding,
              children:
                  _messageSuggestions.map((final text) {
                    return AppChoiceChip(
                      label: text,
                      selected: _messageController.text == text,
                      onSelected: (final _) {
                        setState(() => _messageController.text = text);
                      },
                    );
                  }).toList(),
            ),
            const CakeSectionTitle('Pickup or delivery'),
            Wrap(
              spacing: Dimens.padding,
              children: [
                AppChoiceChip(
                  label: 'Pickup from shop',
                  selected: !_isDelivery,
                  onSelected:
                      (final _) => setState(
                        () => _fulfillment = FulfillmentType.pickup,
                      ),
                ),
                AppChoiceChip(
                  label:
                      'Delivery (+ \$ ${CakeOptions.deliveryFee.toStringAsFixed(0)})',
                  selected: _isDelivery,
                  onSelected:
                      (final _) => setState(
                        () => _fulfillment = FulfillmentType.delivery,
                      ),
                ),
              ],
            ),
            if (_isDelivery)
              CakeTextField(
                controller: _addressController,
                hint: 'Delivery address',
                maxLines: 2,
                prefixIcon: Icons.location_on_outlined,
                errorText: addressError ? 'Please enter the address' : null,
                onChanged: (final _) {
                  if (_submitted) setState(() {});
                },
              ),
            CakeSectionTitle(_isDelivery ? 'Delivery date' : 'Pickup date'),
            BorderedContainer(
              borderRadius: Dimens.smallCorners,
              borderColor: dateError ? appColors.error : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.smallCorners),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _pickDate,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.largePadding),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: appColors.primary,
                          ),
                          const SizedBox(width: Dimens.mediumPadding),
                          Expanded(
                            child: Text(
                              _date == null
                                  ? 'Select a date'
                                  : formatCakeDate(_date!),
                              style: appTypography.bodyMedium.copyWith(
                                color: _date == null ? appColors.gray4 : null,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right, color: appColors.gray4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              dateError
                  ? 'Please select a date'
                  : 'Custom cakes need at least ${CakeOptions.minLeadDays} days to prepare.',
              style: appTypography.bodySmall.copyWith(
                color: dateError ? appColors.error : appColors.gray4,
              ),
            ),
            CakeSectionTitle(_isDelivery ? 'Delivery time' : 'Pickup time'),
            if (_date == null)
              Text(
                'Select a date first to see the available times.',
                style: appTypography.bodySmall.copyWith(
                  color: appColors.gray4,
                ),
              )
            else
              Wrap(
                spacing: Dimens.padding,
                runSpacing: Dimens.smallPadding,
                children: List<Widget>.generate(CakeOptions.timeSlots.length, (
                  final index,
                ) {
                  final slot = CakeOptions.timeSlots[index];
                  final available = _isSlotAvailable(_date!, index);
                  final selected = _slot == slot;
                  return ChoiceChip(
                    label: Text(slot),
                    selected: selected,
                    showCheckmark: false,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    selectedColor: appColors.primary,
                    onSelected:
                        available ? (final _) => setState(() => _slot = slot) : null,
                    labelStyle: TextStyle(
                      color:
                          !available
                              ? appColors.gray2
                              : selected
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black),
                      decoration: available ? null : TextDecoration.lineThrough,
                    ),
                  );
                }),
              ),
            if (slotError)
              Text(
                'Please select a time',
                style: appTypography.bodySmall.copyWith(color: appColors.error),
              ),
            const SizedBox(height: Dimens.largePadding),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimens.largePadding,
            Dimens.padding,
            Dimens.largePadding,
            Dimens.padding,
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: appTypography.bodySmall.copyWith(
                      color: appColors.gray4,
                    ),
                  ),
                  Text(
                    formatPrice(_total),
                    style: appTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: appColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Dimens.largePadding),
              Expanded(
                child: AppButton(
                  title: 'Review order',
                  textStyle: appTypography.bodyLarge,
                  borderRadius: Dimens.corners,
                  margin: EdgeInsets.zero,
                  onPressed: _onReview,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
