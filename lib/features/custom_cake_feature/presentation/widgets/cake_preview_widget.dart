import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';

import '../../data/models/cake_option_model.dart';

/// A simple live preview of the cake that updates while the user builds it.
class CakePreviewWidget extends StatelessWidget {
  const CakePreviewWidget({
    super.key,
    required this.size,
    required this.flavor,
    required this.design,
    required this.message,
  });

  final CakeOption size;
  final CakeOption flavor;
  final CakeOption design;
  final String message;

  double get _scale {
    switch (size.id) {
      case 'small':
        return 0.6;
      case 'medium':
        return 0.75;
      case 'large':
        return 0.9;
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    final textColor =
        ThemeData.estimateBrightnessForColor(flavor.color) == Brightness.dark
            ? Colors.white
            : Colors.black87;
    final cakeWidth = 230.0 * _scale;

    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimens.corners),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Candle
          Container(
            width: 6,
            height: 22,
            decoration: BoxDecoration(
              color: appColors.brownExtraLight,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 2),
          // Frosting
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: cakeWidth,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              border: Border.all(color: appColors.gray2.withValues(alpha: 0.5)),
            ),
          ),
          // Sponge with the design icon and the message
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: cakeWidth,
            height: 96,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.padding,
              vertical: Dimens.smallPadding,
            ),
            decoration: BoxDecoration(
              color: flavor.color,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(design.icon, color: textColor, size: 26),
                const SizedBox(height: 4),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      message.trim().isEmpty ? '' : message.trim(),
                      maxLines: 1,
                      style: appTypography.bodyMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Plate
          Container(
            width: cakeWidth + 24,
            height: 7,
            decoration: BoxDecoration(
              color: appColors.gray2,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
