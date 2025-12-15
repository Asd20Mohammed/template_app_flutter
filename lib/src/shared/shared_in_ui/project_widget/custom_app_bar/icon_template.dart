import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IconTemplate extends StatelessWidget {
  final IconData? icon;
  final Function? onTap;

  const IconTemplate({super.key, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Card(
        // borderRadius: BorderRadius.circular(8.0),
        // color: AppColors.secondaryColor5.withValues(alpha:0.8),
        margin: const EdgeInsets.all(0),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: Colors.yellow, width: 0.5),
        ),
        // shadowColor: Colors.grey.withValues(alpha:0.5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(icon, color: Get.iconColor),
        ),
      ),
    );
  }
}
