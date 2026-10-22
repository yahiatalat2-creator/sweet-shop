import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';

class CakeInfoRow extends StatelessWidget {
  const CakeInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final appTypography = context.theme.appTypography;
    final appColors = context.theme.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: appTypography.bodyMedium.copyWith(
              color: bold ? null : appColors.gray4,
              fontWeight: bold ? FontWeight.w700 : null,
            ),
          ),
          const SizedBox(width: Dimens.largePadding),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: appTypography.bodyMedium.copyWith(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                color: bold ? appColors.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
