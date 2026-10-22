import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';

class CakeSectionTitle extends StatelessWidget {
  const CakeSectionTitle(this.title, {super.key, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final appTypography = context.theme.appTypography;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: appTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: appTypography.bodySmall.copyWith(
              color: context.theme.appColors.gray4,
            ),
          ),
      ],
    );
  }
}
