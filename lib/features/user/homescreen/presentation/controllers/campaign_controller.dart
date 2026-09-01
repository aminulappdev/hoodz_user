import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/all_campaign_model.dart'
    as campaign_model;
import 'package:hoodz/urls.dart';

class CampaignController extends GetxController {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;
  final RxString reference = ''.obs;
  final RxString title = ''.obs;
  final RxString banner = ''.obs;
  final Rx<campaign_model.AllCampaignProductModel?> _campaignModel =
      Rx<campaign_model.AllCampaignProductModel?>(null);

  bool _initialized = false;

  campaign_model.AllCampaignProductModel? get campaignModel =>
      _campaignModel.value;

  List<campaign_model.Product> get products => _campaignModel.value?.data
      .expand((campaign) => campaign.products)
      .toList(growable: false) ?? const [];

  void initialize(Map<String, dynamic>? arguments) {
    if (_initialized) return;
    _initialized = true;

    reference.value = arguments?['reference']?.toString().trim() ?? '';
    title.value = arguments?['title']?.toString().trim() ?? '';
    banner.value = arguments?['banner']?.toString().trim() ?? '';

    if (reference.value.isEmpty) {
      showAppToast(message: Strings.noProductsFound.tr, isError: true);
      return;
    }

    fetchCampaign();
  }

  Future<void> fetchCampaign() async {
    if (reference.value.isEmpty || isLoading.value) return;

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _networkCaller.getRequest(
        Urls.campaignUrl,
        accessToken: accessToken
        // queryParams: {'reference': reference.value},
      );

      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return;
      }

      final model = campaign_model.AllCampaignProductModel.fromJson(
        response.responseData,
      );
      _campaignModel.value = model;

      if (title.value.isEmpty && model.data.isNotEmpty) {
        title.value = model.data.first.title?.trim() ?? '';
      }
    } catch (error) {
      showAppToast(message: '${Strings.noProductsFound.tr} $error', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
