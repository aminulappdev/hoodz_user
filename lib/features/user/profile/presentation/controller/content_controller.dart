import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/urls.dart';

class ContentController extends GetxController {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();
  final RxBool isLoading = false.obs;
  final RxString pageTitle = 'Content'.obs;
  final RxString contentKey = ''.obs;
  final RxString htmlContent = ''.obs;

  Future<void> loadContent({
    required String key,
    required String title,
  }) async {
    final normalizedKey = key.trim();
    if (normalizedKey.isEmpty) {
      return;
    }

    if (contentKey.value == normalizedKey && htmlContent.value.isNotEmpty) {
      pageTitle.value = title;
      return;
    }

    pageTitle.value = title;
    contentKey.value = normalizedKey;
    htmlContent.value = '';

    try {
      isLoading.value = true;
      final response = await _networkCaller.getRequest(
        Urls.settingsUrl,
        queryParams: {'key': normalizedKey},
      );

      if (isLoginRequiredResponse(response)) {
        htmlContent.value = '';
        showLoginRequiredDialog();
        return;
      }

      if (!response.isSuccess) {
        htmlContent.value = '';
        showAppToast(message: response.errorMessage, isError: true);
        return;
      }

      final value = _extractContentValue(response.responseData);
      htmlContent.value = value;
    } finally {
      isLoading.value = false;
    }
  }

  String _extractContentValue(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is Map<String, dynamic>) {
        final value = data['value'];
        if (value != null) {
          return value.toString();
        }
      }

      final directValue = responseData['value'];
      if (directValue != null) {
        return directValue.toString();
      }
    }

    return '';
  }
}
