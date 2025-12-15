import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:template_app/src/core/utils/responsive_size.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker_widget/image_picker_widget.dart';

import '/src/core/language/app_strings.dart';
import '/src/core/constants/app_images.dart';
import '../auto_direction_text.dart';

class ImagePickerFormBuilderField extends StatelessWidget {
  final dynamic initialImage;
  final String? title;
  final String keyName;
  final bool isRequired;
  final bool showEditIcon;
  final double diameter;

  final double? height;
  final double? width;
  final double? squareBorderRadius;
  final ImagePickerWidgetShape? shape;
  final EdgeInsetsGeometry? paddingIcon;
  final Color? backgroundColor;
  final Function(dynamic)? onChange;
  final bool isMemberPlaceHolder;
  final bool isGroupPlaceHolder;
  // final Function onChange;

  const ImagePickerFormBuilderField({
    super.key,
    this.initialImage,
    required this.keyName,
    this.isRequired = false,
    this.diameter = 120,
    this.title,
    this.shape,
    this.height,
    this.width,
    this.paddingIcon,
    this.backgroundColor,
    this.showEditIcon = true,
    this.squareBorderRadius,
    this.onChange,
    this.isMemberPlaceHolder = true,
    this.isGroupPlaceHolder = false,
  });

  dynamic get getInitialImage {
    if (initialImage != '' && initialImage != null && initialImage is String) {
      return CachedNetworkImageProvider(
        initialImage,
        errorListener: (error) {
          return;
        },
      );
    }
    return AssetImage(
      isMemberPlaceHolder
          ? AppImages.profilePlaceholderImage
          : AppImages.logoPlaceHolder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: AutoDirectionText(
            title ?? '',
            style: Get.textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FormBuilderField(
          name: keyName,
          onChanged: onChange,
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
          initialValue: initialImage,
          builder: (FormFieldState field) {
            return InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                border: InputBorder.none,
                errorText: field.errorText,
                filled: false,
              ),
              child: Center(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: ImagePickerWidget(
                    diameter: width ?? diameter.r,
                    // borderRadius: const Radius.circular(16.0),
                    backgroundColor: Colors.transparent,
                    // iconAlignment: AlignmentDirectional.bottomStart,
                    initialImage: getInitialImage,
                    shape: shape ?? ImagePickerWidgetShape.circle,
                    isEditable: true,
                    onChange: (File val) {
                      field.didChange(val);
                    },
                    editIcon: showEditIcon ? Icon(Icons.edit) : Container(),

                    ///..
                    modalOptions: ModalOptions(
                      title: AutoDirectionText(
                        AppStrings.pleaseSelectImageFirst.tr.capitalizeFirst!,
                      ),
                      // cameraIcon: Icons.camera_alt,
                      // galleryIcon: Icons.photo_library,
                      cameraText: AutoDirectionText(
                        AppStrings.camera.tr.capitalizeFirst!,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      galleryText: AutoDirectionText(
                        AppStrings.gallery.tr.capitalizeFirst!,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
