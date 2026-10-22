import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/check_theme_status.dart';

import '../../data/models/cake_option_model.dart';

/// Two-column grid of selectable option cards (size / flavor / design).
class CakeOptionSelector extends StatelessWidget {
  const CakeOptionSelector({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
    this.showBasePrice = false,
  });

  final List<CakeOption> options;
  final String selectedId;
  final ValueChanged<CakeOption> onSelected;

  /// Sizes show their full price, flavors and designs show "+ extra".
  final bool showBasePrice;

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    final isDark = checkDarkMode(context);

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final tileWidth = (constraints.maxWidth - Dimens.padding) / 2;
        return Wrap(
          spacing: Dimens.padding,
          runSpacing: Dimens.padding,
          children:
              options.map((final option) {
                final selected = option.id == selectedId;
                final priceText =
                    showBasePrice
                        ? '\$ ${option.price.toStringAsFixed(0)}'
                        : (option.price == 0
                            ? 'Free'
                            : '+ \$ ${option.price.toStringAsFixed(0)}');
                return SizedBox(
                  width: tileWidth,
                  child: Material(
                    color:
                        selected
                            ? appColors.primary.withValues(alpha: 0.12)
                            : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.smallCorners),
                      side: BorderSide(
                        width: selected ? 1.5 : 1,
                        color:
                            selected
                                ? appColors.primary
                                : (isDark
                                    ? appColors.gray.withValues(alpha: 0.2)
                                    : appColors.gray2),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Dimens.smallCorners),
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.mediumPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: option.color.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Icon(
                                    option.icon,
                                    size: 16,
                                    color: option.color,
                                  ),
                                ),
                                const SizedBox(width: Dimens.padding),
                                Expanded(
                                  child: Text(
                                    option.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: appTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimens.padding),
                            Text(
                              option.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appTypography.bodySmall.copyWith(
                                color: appColors.gray4,
                              ),
                            ),
                            const SizedBox(height: Dimens.smallPadding),
                            Text(
                              priceText,
                              style: appTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: appColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
