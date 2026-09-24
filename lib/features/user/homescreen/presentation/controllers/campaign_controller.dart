import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/all_campaign_model.dart'
    as campaign_model;
import 'package:hoodz/urls.dart';

class CampaignController extends GetxController {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;
  final RxString reference = ''.obs;
  final RxString bannerId = ''.obs;
  final RxString title = ''.obs;
  final RxString banner = ''.obs;
  final Rx<campaign_model.AllCampaignProductModel?> _campaignModel =
      Rx<campaign_model.AllCampaignProductModel?>(null);

  bool _initialized = false;

  campaign_model.AllCampaignProductModel? get campaignModel =>
      _campaignModel.value;

  List<campaign_model.Product> get products =>
      _campaignModel.value?.data
          .expand((campaign) => campaign.products)
          .toList(growable: false) ??
      const [];

  String get displayTitle {
    final campaignTitle = _campaignModel.value?.data.isNotEmpty == true
        ? _campaignModel.value!.data.first.displayTitle
        : '';
    if (campaignTitle.trim().isNotEmpty) {
      return campaignTitle;
    }
    return title.value;
  }

  void initialize(Map<String, dynamic>? arguments) {
    if (_initialized) return;
    _initialized = true;

    bannerId.value = arguments?['bannerId']?.toString().trim() ?? '';
    reference.value = arguments?['reference']?.toString().trim() ?? '';
    title.value = arguments?['title']?.toString().trim() ?? '';
    banner.value = arguments?['banner']?.toString().trim() ?? '';

    if (bannerId.value.isEmpty) {
      bannerId.value = reference.value;
    }

    if (bannerId.value.isEmpty) {
      showAppToast(message: Strings.noProductsFound.tr, isError: true);
      return;
    }

    fetchCampaign();
  }

  Future<void> fetchCampaign() async {
    if (bannerId.value.isEmpty || isLoading.value) return;

    final accessToken = MySharedPref.getAccessToken();
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;

    isLoading.value = true;
    try {
      final response = hasAccessToken
          ? await _networkCaller.getRequest(
              Urls.getCampaignBannerUrl(bannerId.value),
              accessToken: accessToken,
            )
          : await _networkCaller.getRequest(
              Urls.getCampaignBannerUrl(bannerId.value),
            );

      if (isLoginRequiredResponse(response)) {
        showLoginRequiredDialog();
        return;
      }

      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return;
      }

      final model = campaign_model.AllCampaignProductModel.fromJson(
        response.responseData,
      );
      _campaignModel.value = model;

      if (title.value.isEmpty && model.data.isNotEmpty) {
        title.value = model.data.first.displayTitle;
      }
    } catch (error) {
      showAppToast(message: '${Strings.noProductsFound.tr} $error', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
