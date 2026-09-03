import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/image_picker_service.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/services/upload_service.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/product_details_controller.dart';
import 'package:hoodz/urls.dart';
import 'package:image_picker/image_picker.dart';

class ProductReviewController extends GetxController {
  ProductReviewController()
      : _networkCaller = Get.find<NetworkCaller>(),
        _uploadService = Get.find<UploadService>(),
        _productDetailsController = Get.find<ProductDetailsController>();

  final NetworkCaller _networkCaller;
  final UploadService _uploadService;
  final ProductDetailsController _productDetailsController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController reviewCtrl = TextEditingController();

  final RxBool isPickingImages = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool showValidationErrors = false.obs;
  final RxDouble rating = 0.0.obs;
  final RxList<File> attachments = <File>[].obs;

  String modelType = 'Product';
  String reference = '';

  void initialize({
    required String reference,
    String modelType = 'Product',
  }) {
    this.reference = reference.trim();
    this.modelType = modelType.trim().isEmpty ? 'Product' : modelType.trim();
    reviewCtrl.clear();
    rating.value = 0.0;
    attachments.clear();
    showValidationErrors.value = false;
    isPickingImages.value = false;
    isSubmitting.value = false;
  }

  void setRating(double value) {
    rating.value = value;
  }

  Future<void> pickImages() async {
    if (isPickingImages.value) {
      return;
    }

    isPickingImages.value = true;
    try {
      final pickedFiles = await ImagePickerService.pickImages(
        ImageSource.gallery,
      );
      if (pickedFiles.isEmpty) {
        return;
      }

      attachments.addAll(pickedFiles);
    } finally {
      isPickingImages.value = false;
    }
  }

  void removeAttachment(int index) {
    if (index < 0 || index >= attachments.length) {
      return;
    }

    attachments.removeAt(index);
  }

  Future<bool> submitReview() async {
    showValidationErrors.value = true;

    if (!ValidatorService.validateAndSave(formKey)) {
      return false;
    }

    final selectedRating = rating.value.round();
    if (selectedRating <= 0) {
      showAppToast(
        message: Strings.pleaseSelectARating.tr,
        isError: true,
      );
      return false;
    }

    final review = reviewCtrl.text.trim();
    if (review.isEmpty) {
      showAppToast(
        message: Strings.pleaseWriteYourReview.tr,
        isError: true,
      );
      return false;
    }

    if (attachments.isEmpty) {
      showAppToast(
        message: Strings.pleaseUploadAtLeastOneImage.tr,
        isError: true,
      );
      return false;
    }

    final resolvedReference = reference.trim();
    if (resolvedReference.isEmpty) {
      showAppToast(
        message: Strings.referenceNotFound.tr,
        isError: true,
      );
      return false;
    }

    final accessToken = MySharedPref.getAccessToken();
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;
    if (!hasAccessToken) {
      showLoginRequiredDialog();
      return false;
    }

    if (isSubmitting.value) {
      return false;
    }

    final uploadedFiles = <String>[];

    await showLoadingOverLay(
      msg: Strings.submittingReview.tr,
      asyncFunction: () async {
        isSubmitting.value = true;
        try {
          for (final file in attachments) {
            final uploadedUrl = await _uploadService.uploadSingleFile(
              accessToken: accessToken!,
              file: file,
            );
            if (uploadedUrl == null || uploadedUrl.isEmpty) {
              showAppToast(
                message: Strings.imageUploadFailed.tr,
                isError: true,
              );
              return;
            }
            uploadedFiles.add(uploadedUrl);
          }

          final response = await _networkCaller.postRequest(
            Urls.reviewsUrl,
            accessToken: accessToken,
            body: {
              'modelType': modelType,
              'reference': resolvedReference,
              'review': review,
              'files': uploadedFiles,
              'rating': selectedRating,
            },
          );

          if (isLoginRequiredResponse(response)) {
            showLoginRequiredDialog();
            return;
          }

          if (!response.isSuccess) {
            showAppToast(message: response.errorMessage, isError: true);
            return;
          }

          if (Get.isRegistered<ProductDetailsController>()) {
            await _productDetailsController.loadProductData(force: true);
          }

          Get.back();
          showAppToast(message: Strings.reviewSubmittedSuccessfully.tr);
          reset();
        } finally {
          isSubmitting.value = false;
        }
      },
    );

    return true;
  }

  void reset() {
    reviewCtrl.clear();
    rating.value = 0.0;
    attachments.clear();
    showValidationErrors.value = false;
    isPickingImages.value = false;
    isSubmitting.value = false;
    reference = '';
    modelType = 'Product';
  }

  @override
  void onClose() {
    reviewCtrl.dispose();
    super.onClose();
  }
}
