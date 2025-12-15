import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import '/src/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircularCachedImageWidget extends StatelessWidget {
  final String? url;
  final File? imageFile;
  final double? radius;
  final double? elevation;
  final double opacity;
  final bool isMemberTemplate;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final bool showLoadingIndicator;
  final Duration loadingDuration;
  final BoxFit fit;

  const CircularCachedImageWidget({
    super.key,
    this.url,
    this.radius,
    this.elevation,
    this.opacity = 1.0,
    this.isMemberTemplate = true,
    this.imageFile,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2.0,
    this.placeholderWidget,
    this.errorWidget,
    this.showLoadingIndicator = true,
    this.loadingDuration = const Duration(milliseconds: 500),
    this.fit = BoxFit.cover,
  });

  static const String placeHolderImage =
      'https://placehold.co/3500x4000/EBEDEF/r.png?text=Your Logo Here';

  String? get imageData {
    if (imageFile != null) {
      return null; // Return null to use imageFile
    }

    if (url != null && url!.isNotEmpty) {
      return url;
    } else {
      if (!isMemberTemplate) {
        return 'https://placehold.co/3500x4000/EAECEE/r.png?text=Your Logo Here';
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return _buildLocalImage();
    }

    return GestureDetector(
      onTap: onTap,
      child: CircularProfileAvatar(
        imageData ?? placeHolderImage,
        cacheImage: true,
        radius: radius ?? 50,
        backgroundColor: Theme.of(context).switchTheme == ThemeMode.dark
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        elevation: elevation ?? 3,
        borderColor: showBorder
            ? (borderColor ?? Theme.of(context).primaryColor)
            : Colors.transparent,
        borderWidth: showBorder ? borderWidth : 0,
        animateFromOldImageOnUrlChange: true,
        imageFit: fit,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
              filterQuality: FilterQuality.medium,
              isAntiAlias: true,
            ),
          ),
        ),
        placeHolder: (context, url) {
          if (placeholderWidget != null) {
            return placeholderWidget!;
          }

          return showLoadingIndicator
              ? Center(
                  child: SizedBox(
                    width: radius != null ? radius! * 0.5 : 25,
                    height: radius != null ? radius! * 0.5 : 25,
                    child: UiHelper.spinKitProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink();
        },
        errorWidget: (context, url, error) {
          if (errorWidget != null) {
            return errorWidget!;
          }
          return buildErrorAndNullUrlWidget();
        },
        child: (imageData == null || imageData!.isEmpty)
            ? buildErrorAndNullUrlWidget()
            : null,
      ),
    );
  }

  Widget _buildLocalImage() {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: radius != null ? radius! * 2 : 100,
            height: radius != null ? radius! * 2 : 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                if (elevation != null && elevation! > 0)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: elevation!,
                    spreadRadius: elevation! * 0.3,
                  ),
              ],
              border: showBorder
                  ? Border.all(
                      color: borderColor ?? Theme.of(context).primaryColor,
                      width: borderWidth,
                    )
                  : null,
              image: DecorationImage(
                image: FileImage(imageFile!),
                fit: fit,
                filterQuality: FilterQuality.medium,
                isAntiAlias: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildErrorAndNullUrlWidget() {
    if (imageFile != null) {
      return _buildLocalImage();
    }

    if (isMemberTemplate) {
      return Builder(
        builder: (context) {
          return Image.asset(
            AppImages.profilePlaceholderImage,
            fit: BoxFit.contain,
            color: Theme.of(context).primaryColor,
            colorBlendMode: BlendMode.color,
            errorBuilder: (context, error, stackTrace) {
              return SvgPicture.asset(AppImages.logoSvg, fit: BoxFit.contain);
            },
          );
        },
      );
    }

    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(AppImages.logoSvg, fit: BoxFit.contain),
      ),
    );
  }
}
