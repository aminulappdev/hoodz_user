import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/payment/presentation/models/card_success_model.dart'
    as card_success;
import 'package:hoodz/features/user/payment/presentation/models/cod_payment_success_model.dart'
    as cod_success;
import 'package:hoodz/urls.dart';

class PaymentInitiateController extends GetxController {
  PaymentInitiateController()
      : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;

  final RxBool isLoading = false.obs;
  final Rxn<card_success.CardPaymentSucessModel> cardPaymentSuccessModel =
      Rxn<card_success.CardPaymentSucessModel>();
  final Rxn<cod_success.CodPaymentSucessModel> codPaymentSuccessModel =
      Rxn<cod_success.CodPaymentSucessModel>();

  card_success.Data? get cardPaymentData => cardPaymentSuccessModel.value?.data;
  cod_success.Data? get codPaymentData => codPaymentSuccessModel.value?.data;

  Future<bool> initiatePayment({
    required List<String> orderIds,
    required String paymentMethod,
    bool saveCard = false,
  }) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return false;
    }

    if (orderIds.isEmpty) {
      showAppToast(message: 'Order ids not found.', isError: true);
      return false;
    }

    final body = <String, dynamic>{
      'orderIds': orderIds,
      'paymentMethod': paymentMethod,
      'saveCard': saveCard,
    };

    bool isSuccess = false;

    await showLoadingOverLay(
      msg: 'Initiating payment...',
      asyncFunction: () async {
        isLoading.value = true;

        try {
          final response = await _networkCaller.postRequest(
            Urls.paymentInitiateUrl,
            accessToken: accessToken,
            body: body,
          );

          if (!response.isSuccess) {
            showAppToast(message: response.errorMessage, isError: true);
            return;
          }

          final responseData = response.responseData;
          if (responseData is! Map<String, dynamic>) {
            showAppToast(
              message: 'Invalid payment initiate response.',
              isError: true,
            );
            return;
          }

          if (paymentMethod == 'card') {
            final model = card_success.CardPaymentSucessModel.fromJson(
              responseData,
            );
            cardPaymentSuccessModel.value = model;
            codPaymentSuccessModel.value = null;
            // ignore: avoid_print
            print('CardPaymentSucessModel => ${model.data?.paymentIntentId}');
            // ignore: avoid_print
            print('CardPaymentSucessModel data => ${model.data}');
          } else {
            final model = cod_success.CodPaymentSucessModel.fromJson(
              responseData,
            );
            codPaymentSuccessModel.value = model;
            cardPaymentSuccessModel.value = null;
            // ignore: avoid_print
            print('CodPaymentSucessModel => ${model.data?.paymentIntentId}');
            // ignore: avoid_print
            print('CodPaymentSucessModel data => ${model.data}');
          }

          isSuccess = true;
        } finally {
          isLoading.value = false;
        }
      },
    );

    return isSuccess;
  }

  void clearPaymentState() {
    cardPaymentSuccessModel.value = null;
    codPaymentSuccessModel.value = null;
  }
}
