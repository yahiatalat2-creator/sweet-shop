import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/check_theme_status.dart';

class CakeTextField extends StatelessWidget {
  const CakeTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.errorText,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final int? maxLength;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final borderColor =
        checkDarkMode(context)
            ? appColors.gray.withValues(alpha: 0.2)
            : appColors.gray2;

    OutlineInputBorder border(final Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.smallCorners),
      borderSide: BorderSide(color: color),
    );

    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: onChanged,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        prefixIcon:
            prefixIcon == null
                ? null
                : Icon(prefixIcon, color: appColors.gray4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.largePadding,
          vertical: Dimens.mediumPadding,
        ),
        enabledBorder: border(borderColor),
        focusedBorder: border(appColors.primary),
        errorBorder: border(appColors.error),
        focusedErrorBorder: border(appColors.error),
      ),
    );
  }
}
