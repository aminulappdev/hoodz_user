import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/product/presentation/controller/product_review_controller.dart';

class ProductReviewBottomSheet extends GetView<ProductReviewController> {
  const ProductReviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          18.w(context),
          14.h(context),
          18.w(context),
          20.h(context) + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26.r(context)),
          ),
        ),
        child: Form(
          key: controller.formKey,
          child: Obx(
            () => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 46.w(context),
                      height: 5.h(context),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(999.r(context)),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h(context)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Strings.addReview.tr,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 18.sp(context),
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF202020),
                                  ),
                        ),
                      ),
                      InkWell(
                        onTap: Get.back,
                        borderRadius: BorderRadius.circular(999.r(context)),
                        child: Container(
                          padding: EdgeInsets.all(8.r(context)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h(context)),
                  Text(
                    Strings.ratingLabel.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2A2A2A),
                        ),
                  ),
                  SizedBox(height: 10.h(context)),
                  RatingBar.builder(
                    initialRating: controller.rating.value,
                    minRating: 1,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 30.w(context),
                    glow: false,
                    itemPadding: EdgeInsets.zero,
                    unratedColor: const Color(0xFFE2E2E2),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFB423),
                    ),
                    onRatingUpdate: controller.setRating,
                  ),
                  if (controller.showValidationErrors.value &&
                      controller.rating.value <= 0) ...[
                    SizedBox(height: 8.h(context)),
                    Text(
                      Strings.pleaseSelectARating.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                            fontSize: 12.sp(context),
                          ),
                    ),
                  ],
                  SizedBox(height: 18.h(context)),
                  Text(
                    Strings.yourReview.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2A2A2A),
                        ),
                  ),
                  SizedBox(height: 10.h(context)),
                  TextFormField(
                    controller: controller.reviewCtrl,
                    validator: ValidatorService.validateSimpleField,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: Strings.writeYourFeedbackHere.tr,
                      filled: true,
                      fillColor: const Color(0xFFF7F7F8),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w(context),
                        vertical: 14.h(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r(context)),
                        borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r(context)),
                        borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r(context)),
                        borderSide: const BorderSide(color: Color(0xFFE8622C)),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h(context)),
                  Text(
                    Strings.uploadImages.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2A2A2A),
                        ),
                  ),
                  SizedBox(height: 10.h(context)),
                  InkWell(
                    onTap: controller.pickImages,
                    borderRadius: BorderRadius.circular(18.r(context)),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w(context),
                        vertical: 18.h(context),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F8),
                        borderRadius: BorderRadius.circular(18.r(context)),
                        border: Border.all(color: const Color(0xFFE8E8E8)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            controller.isPickingImages.value
                                ? Icons.hourglass_empty_rounded
                                : Icons.cloud_upload_outlined,
                            color: const Color(0xFFE8622C),
                            size: 28.sp(context),
                          ),
                          SizedBox(height: 10.h(context)),
                          Text(
                            controller.isPickingImages.value
                                ? Strings.pickingImages.tr
                                : Strings.tapToAddMultiplePhotos.tr,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.sp(context),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF303030),
                                    ),
                          ),
                          SizedBox(height: 6.h(context)),
                          Text(
                            Strings.chooseMultipleImages.tr,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12.sp(context),
                                      color: const Color(0xFF777777),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.showValidationErrors.value &&
                      controller.attachments.isEmpty) ...[
                    SizedBox(height: 8.h(context)),
                    Text(
                      Strings.pleaseUploadAtLeastOneImage.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                            fontSize: 12.sp(context),
                          ),
                    ),
                  ],
                  if (controller.attachments.isNotEmpty) ...[
                    SizedBox(height: 14.h(context)),
                    SizedBox(
                      height: 84.h(context),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.attachments.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: 10.w(context)),
                        itemBuilder: (context, index) {
                          final file = controller.attachments[index];
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  14.r(context),
                                ),
                                child: Image.file(
                                  file,
                                  width: 84.w(context),
                                  height: 84.h(context),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 84.w(context),
                                    height: 84.h(context),
                                    color: const Color(0xFFF2F2F2),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -6,
                                right: -6,
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.removeAttachment(index),
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: const BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 22.h(context)),
                  CustomButton(
                    height: 48.h(context),
                    text: controller.isSubmitting.value
                        ? Strings.submittingReview.tr
                        : Strings.submitReview.tr,
                    enabled: !controller.isSubmitting.value,
                    onPressed: controller.submitReview,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
