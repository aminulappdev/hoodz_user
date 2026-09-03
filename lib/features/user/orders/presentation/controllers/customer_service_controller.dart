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
import 'package:hoodz/features/user/chat/presentation/controllers/chat_system_controller.dart';
import 'package:hoodz/urls.dart';
import 'package:image_picker/image_picker.dart';

class CustomerServiceController extends GetxController {
  CustomerServiceController(this._networkCaller);

  final NetworkCaller _networkCaller;
  final UploadService _uploadService = Get.find<UploadService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController noteCtrl = TextEditingController();

  final RxBool isPickingImages = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxnInt selectedIssueIndex = RxnInt();
  final RxString orderId = ''.obs;
  final RxList<File> attachments = <File>[].obs;

  List<CustomerServiceIssueOption> get issueOptions => [
        CustomerServiceIssueOption(
          label: Strings.missingOrWrongItem.tr,
          issueType: 'missing_or_wrong_item',
        ),
        CustomerServiceIssueOption(
          label: Strings.itemQualityIssues.tr,
          issueType: 'item_quality_issues',
        ),
        CustomerServiceIssueOption(
          label: Strings.receivedTheWrongOrder.tr,
          issueType: 'wrong_order_received',
        ),
        CustomerServiceIssueOption(
          label: Strings.refundsAndPayments.tr,
          issueType: 'refunds_and_payments',
        ),
        CustomerServiceIssueOption(
          label: Strings.somethingElse.tr,
          issueType: 'something_else',
        ),
      ];

  @override
  void onInit() {
    super.onInit();
    initializeFromArguments(Get.arguments);
  }

  void initializeFromArguments(Object? arguments) {
    if (arguments is! Map) {
      return;
    }

    final resolvedOrderId = arguments['orderId'];
    if (resolvedOrderId is String && resolvedOrderId.isNotEmpty) {
      orderId.value = resolvedOrderId;
    }
  }

  void selectIssue(int index) {
    if (index < 0 || index >= issueOptions.length) {
      return;
    }

    selectedIssueIndex.value = index;
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

  Future<bool> submitGrievance() async {
    if (!ValidatorService.validateAndSave(formKey)) {
      return false;
    }

    final selectedIndex = selectedIssueIndex.value;
    if (selectedIndex == null) {
      showAppToast(
        message: Strings.pleaseSelectAnIssueFirst.tr,
        isError: true,
      );
      return false;
    }

    final description = noteCtrl.text.trim();
    if (description.isEmpty) {
      showAppToast(
        message: Strings.pleaseWriteANoteFirst.tr,
        isError: true,
      );
      return false;
    }

    final resolvedOrderId = orderId.value.trim();
    if (resolvedOrderId.isEmpty) {
      showAppToast(
        message: Strings.orderIdNotFound.tr,
        isError: true,
      );
      return false;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      showLoginRequiredDialog();
      return false;
    }

    final issue = issueOptions[selectedIndex];
    final uploadedFiles = <String>[];

    await showLoadingOverLay(
      msg: Strings.submittingGrievance.tr,
      asyncFunction: () async {
        isSubmitting.value = true;

        try {
          for (final file in attachments) {
            final uploadedUrl = await _uploadService.uploadSingleFile(
              accessToken: accessToken,
              file: file,
            );
            if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
              uploadedFiles.add(uploadedUrl);
            }
          }

          if (attachments.isNotEmpty && uploadedFiles.isEmpty) {
            showAppToast(
              message: Strings.imageUploadFailed.tr,
              isError: true,
            );
            return;
          }

          final response = await _networkCaller.postRequest(
            Urls.grievanceUrl,
            accessToken: accessToken,
            body: {
              'order': resolvedOrderId,
              'issueType': issue.issueType,
              'description': description,
              'files': uploadedFiles,
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

          print('successful done');
          noteCtrl.clear();
          attachments.clear();
          selectedIssueIndex.value = null;

          await Get.find<ChatSystemController>().createOrderSupportChat(
            orderId: resolvedOrderId,
          );
        } finally {
          isSubmitting.value = false;
        }
      },
    );

    return true;
  }

  @override
  void onClose() {
    noteCtrl.dispose();
    super.onClose();
  }
}

class CustomerServiceIssueOption {
  const CustomerServiceIssueOption({
    required this.label,
    required this.issueType,
  });

  final String label;
  final String issueType;
}
