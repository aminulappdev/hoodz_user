import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/payment/data/models/wallet_top_up_model.dart'
    as top_up;
import 'package:hoodz/urls.dart';

class WalletTopUpController extends GetxController {
  WalletTopUpController() : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;
  final TextEditingController amountController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxInt selectedMethodIndex = 1.obs;

  void setAmount(int amount) {
    amountController.text = amount.toString();
    amountController.selection = TextSelection.collapsed(
      offset: amountController.text.length,
    );
  }

  void selectMethod(int index) {
    selectedMethodIndex.value = index;
  }

  String get selectedMethodLabel =>
      selectedMethodIndex.value == 0
          ? Strings.savedCard.tr
          : Strings.debitCreditCard.tr;

  Future<top_up.WalletTopUpModel?> addWalletMoney() async {
    final amount = int.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      showAppToast(message: Strings.pleaseEnterAValidAmount.tr, isError: true);
      return null;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      showLoginRequiredDialog();
      return null;
    }

    top_up.WalletTopUpModel? result;

    await showLoadingOverLay(
      msg: Strings.addBalance.tr,
      asyncFunction: () async {
        isLoading.value = true;

        try {
          final response = await _networkCaller.postRequest(
            Urls.walletTopUpUrl,
            accessToken: accessToken,
            body: {
              'amount': amount,
              'paymentMethod': 'card',
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

          final responseData = response.responseData;
          if (responseData is! Map<String, dynamic>) {
            showAppToast(
              message: Strings.invalidWalletTransactionResponse.tr,
              isError: true,
            );
            return;
          }

          result = top_up.WalletTopUpModel.fromJson(responseData);
        } finally {
          isLoading.value = false;
        }
      },
    );

    return result;
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
