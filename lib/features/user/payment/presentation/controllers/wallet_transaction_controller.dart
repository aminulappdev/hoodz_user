import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/payment/data/models/wallet_transaction_model.dart'
    as wallet;
import 'package:hoodz/features/user/payment/presentation/models/transaction_item_model.dart';
import 'package:hoodz/urls.dart';

class WalletTransactionController extends GetxController {
  WalletTransactionController() : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;

  final RxBool isLoading = false.obs;
  final Rxn<wallet.WalletTransactionModel> _walletTransactionModel =
      Rxn<wallet.WalletTransactionModel>();

  wallet.WalletTransactionModel? get walletTransactionModel =>
      _walletTransactionModel.value;

  wallet.Data? get walletData => _walletTransactionModel.value?.data;

  int get walletBalance => walletData?.walletBalance ?? 0;

  String get walletBalanceText => '\$$walletBalance';

  List<TransactionItem> get walletHistoryItems {
    final transactions = walletData?.transactions ?? const <wallet.Transaction>[];

    return transactions.map((transaction) {
      final dateText = _formatDate(transaction.createdAt);
      final amountText = _formatAmount(transaction.amount, transaction.direction);
      final titleText = _firstNonEmpty([
        transaction.note,
        transaction.referenceType,
        transaction.type,
      ]) ?? Strings.walletTransaction.tr;

      return TransactionItem(
        title: titleText,
        date: dateText,
        amount: amountText,
        paymentLabel: '',
        isWalletHistory: true,
      );
    }).toList();
  }

  Future<bool> fetchWalletTransactions() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return false;
    }

    bool isSuccess = false;

    await showLoadingOverLay(
      msg: Strings.loadingWalletHistory.tr,
      asyncFunction: () async {
        isLoading.value = true;

        try {
          final response = await _networkCaller.getRequest(
            Urls.walletTransactionsUrl,
            accessToken: accessToken,
          );

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

          _walletTransactionModel.value =
              wallet.WalletTransactionModel.fromJson(responseData);
          isSuccess = true;
        } finally {
          isLoading.value = false;
        }
      },
    );

    return isSuccess;
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return Strings.notAvailable.tr;
    }

    return DateFormat('MMM d, y - h:mm a').format(dateTime.toLocal());
  }

  String _formatAmount(int? amount, String? direction) {
    final value = amount ?? 0;
    final normalizedDirection = direction?.toLowerCase() ?? '';
    final isDebit =
        normalizedDirection.contains('debit') ||
        normalizedDirection.contains('deduct') ||
        normalizedDirection.contains('out');
    final prefix = isDebit ? '-' : '+';
    return '$prefix${value.toString()}';
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        return trimmed;
      }
    }

    return null;
  }
}
