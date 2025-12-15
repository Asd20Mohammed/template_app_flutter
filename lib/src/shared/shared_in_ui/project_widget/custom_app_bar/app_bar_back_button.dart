import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auto_direction_text.dart';

class CustomBackAppBar extends AppBar {
  CustomBackAppBar({
    super.key,
    String? titleText,
    // يمكنك إضافة أي متغيرات أخرى حسب حاجتك (مثل الألوان أو الأكشنز ...إلخ)
  }) : super(
         automaticallyImplyLeading: false,
         // ارتفاع الـAppBar (يمكنك تخصيصه أو استخدامه كما هو)
         toolbarHeight: kToolbarHeight,
         elevation: 0,
         // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
         centerTitle: true,
         // إذا أردت عنوانًا بسيطًا
         title: titleText != null
             ? AutoDirectionText(
                 titleText,
                 style: Theme.of(
                   Get.context!,
                 ).textTheme.titleLarge?.copyWith(color: Colors.black),
               )
             : null,
         // زر الرجوع المخصَّص
         leading: Builder(
           builder: (context) {
             // 1) التحقق هل يمكن الرجوع عبر Navigator (canPop)
             if (Navigator.of(context).canPop()) {
               return IconButton(
                 icon: Icon(
                   GetPlatform.isAndroid
                       ? Icons.arrow_back
                       : Icons.arrow_back_ios,
                 ),
                 onPressed: () {
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                     Navigator.of(context).pop();
                   });
                 },
               );
             } else {
               // 2) في حال لا يمكن الرجوع (ربما في الواجهة الأساسية)، نفحص مسار Get.currentRoute
               final String path = Get.currentRoute;
               final parts = path.split('/');

               if (parts.length <= 2) {
                 // إذا كان المسار قصيرًا جدًا (لا يوجد ما نتراجع له)
                 return const SizedBox.shrink();
               } else {
                 // يمكن حذف الجزء الأخير من المسار للرجوع خطوة واحدة
                 final newPath = path.substring(0, path.lastIndexOf("/"));

                 return IconButton(
                   icon: Icon(
                     GetPlatform.isAndroid
                         ? Icons.arrow_back
                         : Icons.arrow_back_ios,
                   ),
                   onPressed: () {
                     Get.toNamed(newPath);
                   },
                 );
               }
             }
           },
         ),
       );
}
