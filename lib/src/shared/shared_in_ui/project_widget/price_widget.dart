// Auto-size-text import removed
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key,
    required this.price,
    this.discountedPrice,
    required this.isDiscountedPrice,
    this.textColor,
    this.isYearly = false,
  });

  final double? price;
  final double? discountedPrice;
  final bool isDiscountedPrice;
  final bool isYearly;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    // bool local = Get.locale?.languageCode == 'ar';
    // local ? 'ريال سعودي' :
    return Text.rich(
      TextSpan(
        text: isYearly ? (price! * 12).toString() : price?.toString() ?? '0.0',
        children: [
          TextSpan(
            text: ' SR',
            style: isDiscountedPrice && isYearly == true
                ? Get.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isYearly
                        ? Colors.grey
                        : textColor ??
                              Theme.of(context).scaffoldBackgroundColor,
                    decoration: isYearly ? TextDecoration.lineThrough : null,
                  )
                : Get.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        textColor ?? Theme.of(context).scaffoldBackgroundColor,
                  ),
          ),
          if (isDiscountedPrice && isYearly == true)
            TextSpan(
              text: ' /$discountedPrice ',
              style: Get.textTheme.titleLarge!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'SR',
                  style: Get.textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
        style: isDiscountedPrice && isYearly == true
            ? Get.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: isYearly
                    ? Colors.grey
                    : textColor ?? Theme.of(context).scaffoldBackgroundColor,
                decoration: isYearly ? TextDecoration.lineThrough : null,
              )
            : Get.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor ?? Theme.of(context).scaffoldBackgroundColor,
              ),
      ),
    );
  }
}
