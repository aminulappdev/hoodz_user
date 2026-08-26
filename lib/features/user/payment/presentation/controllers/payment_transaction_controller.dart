import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/payment/data/models/payment_transaction.dart'
    as payment;
import 'package:hoodz/features/user/payment/presentation/models/transaction_item_model.dart';
import 'package:hoodz/urls.dart';

class PaymentTransactionController extends GetxController {
  PaymentTransactionController() : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;

  final RxBool isLoading = false.obs;
  final Rxn<payment.PaymentTransactionModel> _paymentTransactionModel =
      Rxn<payment.PaymentTransactionModel>();

  payment.PaymentTransactionModel? get paymentTransactionModel =>
      _paymentTransactionModel.value;

  payment.Data? get paymentData => _paymentTransactionModel.value?.data;

  int get walletBalance => paymentData?.walletBalance ?? 0;

  String get walletBalanceText => '\$$walletBalance';

  List<TransactionItem> get recentTransactionItems {
    final transactions = paymentData?.transactions ?? const <payment.Transaction>[];

    return transactions.map((transaction) {
      final titleText = _firstNonEmpty([
        transaction.order?.orderId != null ? 'Order #${transaction.order!.orderId}' : null,
        transaction.paymentIntentId,
        transaction.transactionId,
        transaction.paymentMethod,
      ]) ?? 'Payment transaction';

      final dateText = _formatDate(transaction.createdAt);
      final amountText = _formatAmount(transaction.amount, transaction.isPaid);
      final paymentLabel = _firstNonEmpty([
            transaction.paymentMethod,
            transaction.status,
          ]) ??
          '';

      return TransactionItem(
        title: titleText,
        date: dateText,
        amount: amountText,
        paymentLabel: paymentLabel,
        isWalletHistory: false,
      );
    }).toList();
  }

  Future<bool> fetchPaymentTransactions() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return false;
    }

    bool isSuccess = false;

    await showLoadingOverLay(
      msg: 'Loading recent transactions...',
      asyncFunction: () async {
        isLoading.value = true;

        try {
          final response = await _networkCaller.getRequest(
            Urls.paymentTransactionsUrl,
            accessToken: accessToken,
          );

          if (!response.isSuccess) {
            showAppToast(message: response.errorMessage, isError: true);
            return;
          }

          final responseData = response.responseData;
          if (responseData is! Map<String, dynamic>) {
            showAppToast(
              message: 'Invalid payment transaction response.',
              isError: true,
            );
            return;
          }

          _paymentTransactionModel.value =
              payment.PaymentTransactionModel.fromJson(responseData);
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
      return 'N/A';
    }

    return DateFormat('MMM d, y - h:mm a').format(dateTime.toLocal());
  }

  String _formatAmount(int? amount, bool? isPaid) {
    final value = amount ?? 0;
    final prefix = isPaid == false ? '+' : '-';
    return '$prefix \$${value.toString()}';
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
