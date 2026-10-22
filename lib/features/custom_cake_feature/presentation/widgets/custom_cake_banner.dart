import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/gen/assets.gen.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/app_navigator.dart';

import '../screens/custom_cake_screen.dart';

/// Entry point of the custom cake feature, shown on the home tab.
class CustomCakeBanner extends StatelessWidget {
  const CustomCakeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.largePadding,
        vertical: Dimens.largePadding,
      ),
      child: Material(
        color: appColors.primary,
        borderRadius: BorderRadius.circular(Dimens.corners),
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimens.corners),
          onTap: () => appPush(context, const CustomCakeScreen()),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.largePadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Design your own cake',
                        style: appTypography.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: Dimens.padding),
                      Text(
                        'Pick the size, flavor and design, add a message and choose your date.',
                        style: appTypography.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: Dimens.mediumPadding),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.largePadding,
                          vertical: Dimens.padding,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Order custom cake',
                          style: appTypography.labelMedium.copyWith(
                            color: appColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Dimens.largePadding),
                Image.asset(
                  Assets.images.cakeIllustration.path,
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
