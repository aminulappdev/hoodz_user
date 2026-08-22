import 'dart:io';

import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/urls.dart';

class UploadService extends GetxService {
  UploadService(this._networkCaller);

  final NetworkCaller _networkCaller;

  Future<String?> uploadSingleFile({
    required String accessToken,
    required File file,
    String keyName = 'files',
  }) async {
    final uploadResponse = await _networkCaller.postRequest(
      Urls.uploadMultipleUrl,
      accessToken: accessToken,
      images: [file],
      keyNameImage: keyName,
    );

    if (!uploadResponse.isSuccess) {
      Get.snackbar('Upload Failed', uploadResponse.errorMessage);
      return null;
    }

    final responseData = uploadResponse.responseData;
    if (responseData is! Map) {
      Get.snackbar('Upload Failed', 'Invalid upload response');
      return null;
    }

    final data = responseData['data'];
    if (data is! List || data.isEmpty) {
      Get.snackbar('Upload Failed', 'Image URL not found in upload response');
      return null;
    }

    final firstItem = data.first;
    if (firstItem is! Map) {
      Get.snackbar('Upload Failed', 'Invalid image data received');
      return null;
    }

    final imageUrl = firstItem['url'];
    if (imageUrl is! String || imageUrl.isEmpty) {
      Get.snackbar('Upload Failed', 'Image URL not found in upload response');
      return null;
    }

    return imageUrl;
  }
}
