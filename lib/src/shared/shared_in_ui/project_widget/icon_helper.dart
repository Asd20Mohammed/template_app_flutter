// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../core/constants/app_images.dart';
// import '../../../core/themes/app_colors.dart';


// class IconHelper extends StatelessWidget {
//   final VoidCallback onHelperIcon;
//   final double? padding;

//   const IconHelper({Key? key, required this.onHelperIcon, this.padding})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       highlightColor: Colors.transparent,
//       splashFactory: InkRipple.splashFactory,
//       splashColor: Theme.of(context).cardColor,
//       borderRadius: const BorderRadius.all(Radius.circular(10)),
//       onTap: onHelperIcon,
//       child: Padding(
//         padding: EdgeInsets.all(padding ?? 12),
//         child: SvgPicture.asset(
//           AppImages.helperYoutubeIcon,
//           colorFilter: const ColorFilter.mode(
//             AppColors.accentColor,
//             BlendMode.srcIn,
//           ),
//           height: 18,
//           width: 18,
//         ),
//       ),
//     );
//   }
// }
