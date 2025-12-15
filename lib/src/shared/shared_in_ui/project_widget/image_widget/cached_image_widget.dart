import 'package:cached_network_image/cached_network_image.dart';
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class RectangularCachedImage extends StatelessWidget {
  const RectangularCachedImage({
    super.key,
    this.imageUrl,
    this.clubImageUrl,
    this.height,
    this.fit = BoxFit.contain,
    this.width,
    this.radius,
    this.onTap,
    this.enableNav = true,
    this.isVisible = true,
    this.bgColor,
    this.showLoadingIndicator = true,
    this.placeholderWidget,
    this.errorWidget,
    this.showPlaceholderOnError = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.maxCacheHeight,
    this.maxCacheWidth,
    this.aspectRatio,
    this.alignment = Alignment.center,
  });

  final String? imageUrl;
  final String? clubImageUrl;
  final double? height;
  final BoxFit fit;
  final double? width;
  final double? radius;
  final Color? bgColor;
  final bool enableNav;
  final bool isVisible;
  final bool showLoadingIndicator;
  final VoidCallback? onTap;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final bool showPlaceholderOnError;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final int? maxCacheHeight;
  final int? maxCacheWidth;
  final double? aspectRatio;
  final Alignment alignment;

  static const String placeHolderImage =
      'https://placehold.co/3500x4000/EBEDEF/r.png?text=Your Logo Here';

  String get imageData {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    } else if (clubImageUrl != null && clubImageUrl!.isNotEmpty) {
      return clubImageUrl!;
    } else {
      return 'https://placehold.co/3500x4000/EAECEE/r.png?text=Your Logo Here';
    }
  }

  BoxFit get boxFitData {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return fit;
    }
    return BoxFit.cover;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 0),
          color: bgColor,
        ),
        child: CachedNetworkImage(
          imageBuilder: (BuildContext context, ImageProvider imageProvider) {
            // Get image dimensions
            imageProvider
                .resolve(ImageConfiguration())
                .addListener(
                  ImageStreamListener((ImageInfo info, bool _) {
                    // print('Image width: ${info.image.width}');
                    // print('Image height: ${info.image.height}');
                  }),
                );
            return InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius ?? 0),
              child: Container(
                height: height,
                width: width,
                alignment: alignment,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius ?? 0),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: boxFitData,
                    alignment: alignment,
                  ),
                ),
              ),
            );
          },
          imageUrl: imageData,
          fit: boxFitData,
          fadeInDuration: fadeInDuration,
          fadeOutDuration: fadeOutDuration,
          filterQuality: FilterQuality.medium,
          memCacheHeight: maxCacheHeight,
          memCacheWidth: maxCacheWidth,
          maxHeightDiskCache: maxCacheHeight,
          maxWidthDiskCache: maxCacheWidth,
          errorWidget: (BuildContext context, String url, Object error) =>
              errorWidget ?? _buildErrorWidget(),
          placeholder: placeholderWidget != null
              ? (context, url) => placeholderWidget!
              : showLoadingIndicator
              ? (context, url) => _buildLoadingWidget()
              : null,
        ),
      ),
    );

    // إذا تم تحديد aspectRatio، نستخدم AspectRatio widget
    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildErrorWidget() {
    if (!showPlaceholderOnError) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
        child: Center(
          child: Icon(
            Icons.broken_image_rounded,
            color: Colors.grey[400],
            size: 32,
          ),
        ),
      );
    }

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(radius ?? 0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image_rounded, color: Colors.grey[400], size: 32),
            if (clubImageUrl != null && clubImageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  clubImageUrl!,
                  width: width,
                  height: height != null ? height! * 0.6 : null,
                  filterQuality: FilterQuality.medium,
                  isAntiAlias: true,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(radius ?? 0),
      ),
      child: Visibility(
        visible: isVisible && showLoadingIndicator,
        child: Center(child: UiHelper.spinKitProgressIndicator()),
      ),
    );
  }
}
