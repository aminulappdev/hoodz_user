import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/services/others/payment_webview_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/orders/data/models/order_summary_model.dart'
    as order_summary;
import 'package:hoodz/features/user/orders/data/models/payment_model.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/product_order_controller.dart';
import 'package:hoodz/features/user/orders/presentation/pages/check_out_popup.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_order_details_card.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_voucher_points_card.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/payment_summary_card.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/play_with_card.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_initiate_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_successfull_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';

const Color kBgGrey = Color(0xFFF6F6F8);

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderSummaryController _orderSummaryController =
      Get.find<OrderSummaryController>();
  final ProductOrderController _productOrderController =
      Get.find<ProductOrderController>();
  final PaymentInitiateController _paymentInitiateController =
      Get.find<PaymentInitiateController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final PaymentWebViewService _paymentWebViewService =
      const PaymentWebViewService();
  final TextEditingController _voucherController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int _selectedPaymentIndex = 0;
  String _selectedDeliveryType = 'regular';
  bool _usePoints = false;

  bool get _hasVoucherCode => _voucherController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _voucherController.addListener(_handleVoucherChanged);
  }

  num get _totalAmountValue =>
      _orderSummaryController.orderSummaryData?.totalAmount ?? 0;

  int get _availableRedeemableCoins {
    final availablePoints = _availablePoints;
    final maxCoinsByAmount = (_totalAmountValue * 0.15 * _coinsPerEgp).floor();
    if (availablePoints < 50 || maxCoinsByAmount < 50) {
      return 0;
    }

    final eligibleCoins = availablePoints < maxCoinsByAmount
        ? availablePoints
        : maxCoinsByAmount;
    return eligibleCoins;
  }

  bool get _canUsePoints => _availableRedeemableCoins >= 50 && !_hasVoucherCode;

  int? get _redeemCoinsValue =>
      _usePoints && _canUsePoints ? _availableRedeemableCoins : null;

  void _syncPointSelection() {
    if (_usePoints && !_canUsePoints && mounted) {
      setState(() {
        _usePoints = false; 
      });
    }
  }

  void _handleVoucherChanged() {
    if (!mounted) {
      return;
    }

    if (_hasVoucherCode && _usePoints) {
      setState(() {
        _usePoints = false;
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _showCoinRulePopup() async {
    if (_hasVoucherCode) {
      showAppToast(
        message: Strings.voucherAlreadyAddedCoinEnableNotAllowed.tr,
        isError: true,
      );
      return;
    }

    showAppToast(
      message: Strings.youAreNotEligibleCheckCoinRules.tr,
      isError: true,
    );
  }

  Future<bool> _submitOrderSummary({required bool showConfirmPopup}) async {
    final note = _noteController.text.trim();
    final voucherCode = _voucherController.text.trim();
    final redeemCoins = _redeemCoinsValue;

    final isSuccess = await _orderSummaryController.createOrderSummary(
      deliveryType: _selectedDeliveryType,
      voucherCode: voucherCode.isEmpty ? null : voucherCode,
      redeemCoins: redeemCoins == 0 ? null : redeemCoins,
      note: note.isEmpty ? null : note,
      usePreviousItems: true,
    );

    if (!isSuccess) {
      return false;
    }

    _syncPointSelection();

    if (showConfirmPopup) {
      await _showConfirmOrderPopup();
    }

    return true;
  }

  Future<void> _handlePlaceOrder() async {
    await _submitOrderSummary(showConfirmPopup: true);
  }

  Future<void> _handlePointsChanged(bool value) async {
    if (value && !_canUsePoints) {
      await _showCoinRulePopup();
      return;
    }

    final previousValue = _usePoints;
    setState(() {
      _usePoints = value;
    });

    final isSuccess = await _submitOrderSummary(showConfirmPopup: false);
    if (!isSuccess && mounted) {
      setState(() {
        _usePoints = previousValue;
      });
    }
  }

  Future<void> _handleContinueOrder() async {
    final note = _noteController.text.trim();
    final voucherCode = _voucherController.text.trim();
    final redeemCoins = _redeemCoinsValue;

    final isSuccess = await _productOrderController.createProductOrder(
      deliveryType: _selectedDeliveryType,
      voucherCode: voucherCode.isEmpty ? null : voucherCode,
      redeemCoins: redeemCoins == 0 ? null : redeemCoins,
      note: note.isEmpty ? null : note,
    );

    if (!mounted || !isSuccess) {
      return;
    }

    final orderIds = _productOrderController.createdOrderIds.toList();
    final paymentInitiated = await _paymentInitiateController.initiatePayment(
      orderIds: orderIds,
      paymentMethod: _selectedPaymentMethodValue,
      saveCard: false,
    );

    if (!mounted || !paymentInitiated) {
      return;
    }

    final paymentSuccessfullController =
        Get.find<PaymentSuccessfullController>();
    paymentSuccessfullController.setOrderId(
      _paymentInitiateController.firstOrderId ??
          (orderIds.isNotEmpty ? orderIds.first : null),
    );

    if (_selectedPaymentMethodValue == 'card') {
      final paymentData = _paymentInitiateController.cardPaymentData;
      final paymentUrl = paymentData?.paymentUrl;
      if (paymentUrl == null || paymentUrl.trim().isEmpty) {
        showAppToast(
          message: Strings.paymentUrlNotFound.tr,
          isError: true,
        );
        return;
      }

      final returnUrl = paymentData?.returnUrl;
      Navigator.of(context).pop();
      await _paymentWebViewService.openCardPayment(
        paymentUrl: paymentUrl,
        returnUrl: returnUrl,
        onPaymentCompleted: () {
          Get.offAllNamed(AppRoutes.paymentSuccessfull);
        },
      );
      return;
    }

    Navigator.of(context).pop();
    PageNavigationService.to(context, AppRoutes.paymentSuccessfull);
  }

  Future<void> _applyVoucherAndPoints() async {
    if (_usePoints) {
      showAppToast(
        message: Strings.alreadyCoinEnabledVoucherApplyNotAllowed.tr,
        isError: true,
      );
      return;
    }

    await _submitOrderSummary(showConfirmPopup: false);
  }

  List<SummaryItem> get _summaryItems {
    final data = _orderSummaryController.orderSummaryData;
    if (data == null) {
      return [
        SummaryItem(Strings.subtotal.tr, '\$0.00'),
        SummaryItem(Strings.discount.tr, '-\$0.00'),
        SummaryItem(Strings.deliveryFee.tr, '\$0.00'),
      ];
    }

    final items = <SummaryItem>[
      SummaryItem(Strings.subtotal.tr, _formatCurrency(data.amount)),
    ];

    final voucherDiscount = data.voucherDiscount ?? 0;
    if (voucherDiscount != 0) {
      items.add(
        SummaryItem(
          Strings.voucherDiscount.tr,
          '-${_formatCurrency(voucherDiscount)}',
        ),
      );
    }

    final coinDiscount = data.coinDiscount ?? 0;
    if (coinDiscount != 0) {
      items.add(
        SummaryItem(
          Strings.coinDiscount.tr,
          '-${_formatCurrency(coinDiscount)}',
        ),
      );
    }

    items.add(
      SummaryItem(Strings.deliveryFee.tr, _formatCurrency(data.deliveryCharge)),
    );

    return items;
  }

  SummaryItem get _summaryTotal {
    final totalAmount = _orderSummaryController.orderSummaryData?.totalAmount;
    return SummaryItem(Strings.totalAmount.tr, _formatCurrency(totalAmount));
  }

  int get _availablePoints => _profileController.userData?.coins ?? 0;

  int get _coinsPerEgp {
    final coinsPerEgp = _profileController.userData?.coinsPerEgp ?? 1;
    return coinsPerEgp <= 0 ? 1 : coinsPerEgp;
  }

  num get _pointDiscountValue => (_redeemCoinsValue ?? 0) / _coinsPerEgp;

  num get _walletBalance =>
      _orderSummaryController.orderSummaryData?.walletBalance ?? 0;

  String get _orderName {
    final billing = _orderSummaryController.orderSummaryData?.billingDetails;
    return billing?.name?.trim().isNotEmpty == true
        ? billing!.name!
        : Strings.notAvailable.tr;
  }

  String get _orderPhone {
    final billing = _orderSummaryController.orderSummaryData?.billingDetails;
    return billing?.phoneNumber?.trim().isNotEmpty == true
        ? billing!.phoneNumber!
        : Strings.notAvailable.tr;
  }

  String get _orderDeliveryType {
    final normalized = _selectedDeliveryType.trim().toLowerCase();
    return normalized == 'instant'
        ? Strings.instantDelivery.tr
        : Strings.regularDelivery.tr;
  }

  String get _orderAddress {
    final billing = _orderSummaryController.orderSummaryData?.billingDetails;
    final pieces =
        <String>[?billing?.address, ?billing?.city, ?billing?.country]
            .where((part) => part.trim().isNotEmpty)
            .map((part) => part.trim())
            .toList();

    return pieces.isEmpty ? Strings.notAvailable.tr : pieces.join(', ');
  }

  String get _availablePointsLabel =>
      '${Strings.availablePoints.tr} $_availablePoints';
  String? get _pointDiscountLabel {
    if (!_usePoints || _redeemCoinsValue == null) {
      return null;
    }

    return '${Strings.coinDiscount.tr} -${_formatCurrency(_pointDiscountValue)}';
  }

  String get _walletLabel =>
      '${Strings.wallet.tr} (\$${_walletBalance.toStringAsFixed(2)})';

  String get _selectedPaymentMethodValue {
    switch (_selectedPaymentIndex) {
      case 0:
        return 'card';
      case 1:
        return 'wallet';
      case 2:
        return 'cod';
      default:
        return 'card';
    }
  }

  String _formatCurrency(num? value) {
    return '\$${(value ?? 0).toDouble().toStringAsFixed(2)}';
  }

  List<OrderItem> _buildPopupItems(order_summary.Data data) {
    final items = data.orders.expand((order) => order.items).toList();

    return items
        .map((item) {
          final product = item.product;
          final name = product?.title?.trim().isNotEmpty == true
              ? product!.title!
              : (item.productId ?? Strings.item.tr);
          final imageUrl = product?.banner?.trim().isNotEmpty == true
              ? product!.banner
              : null;
          final price = item.unitPrice ?? item.totalPrice ?? 0;

          return OrderItem(
            name: name,
            size: item.size ?? Strings.notAvailable.tr,
            quantity: item.quantity ?? 1,
            price: price.toDouble(),
            imageUrl: imageUrl,
          );
        })
        .toList(growable: false);
  }

  String _buildDeliveryAddress(order_summary.Data data) {
    final billing = data.billingDetails;
    final parts =
        <String>[
              billing?.address ?? '',
              billing?.city ?? '',
              billing?.country ?? '',
            ]
            .where((part) => part.trim().isNotEmpty)
            .map((part) => part.trim())
            .toList();

    if (parts.isNotEmpty) {
      return parts.join(', ');
    }

    return billing?.address?.trim().isNotEmpty == true
        ? billing!.address!
        : Strings.notAvailable.tr;
  }

  Future<void> _showConfirmOrderPopup() async {
    final data = _orderSummaryController.orderSummaryData;
    if (data == null || !mounted) {
      return;
    }

    await showConfirmOrderSheet(
      context,
      deliveryAddress: _buildDeliveryAddress(data),
      items: _buildPopupItems(data),
      onEditOrder: () {
        Navigator.of(context).pop();
      },
      onContinue: () {
        _handleContinueOrder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      appBar: CustomAppBar(label: Strings.checkout.tr),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              children: [
                Obx(
                  () => CheckoutOrderDetailsCard(
                    onChangeTap: () async {
                      PageNavigationService.to(
                        context,
                        AppRoutes.savedDeliveryLocation,
                      );
                    },
                    name: _orderName,
                    phone: _orderPhone,
                    deliveryType: _orderDeliveryType,
                    address: _orderAddress,
                  ),
                ),
                const SizedBox(height: 14),
                Obx(
                  () => CheckoutVoucherPointsCard(
                    voucherController: _voucherController,
                    isPointsEnabled: _usePoints,
                    isPointsToggleEnabled: _canUsePoints,
                    onPointsChanged: _handlePointsChanged,
                    onInvalidPointsAttempt: _showCoinRulePopup,
                    onApplyVoucher: _applyVoucherAndPoints,
                    availablePointsLabel: _availablePointsLabel,
                    pointDiscountLabel: _pointDiscountLabel,
                  ),
                ),

                const SizedBox(height: 14),
                _CheckoutSection(
                  title: Strings.deliveryType.tr,
                  child: CustomTextField(
                    hintText: Strings.select.tr,
                    value: _selectedDeliveryType == 'regular'
                        ? Strings.regularDelivery.tr
                        : Strings.instantDelivery.tr,
                    onChanged: (value) async {
                      final nextDeliveryType = value ==
                              Strings.instantDelivery.tr
                          ? 'instant'
                          : 'regular';

                      setState(() {
                        _selectedDeliveryType = nextDeliveryType;
                      });

                      await _submitOrderSummary(showConfirmPopup: false);
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: Strings.regularDelivery.tr,
                        child: Text(
                          Strings.regularDelivery.tr,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 15.sp(context),
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: Strings.instantDelivery.tr,
                        child: Text(
                          Strings.instantDelivery.tr,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 15.sp(context),
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                PayWithSection(
                  selectedIndex: _selectedPaymentIndex,
                  onSelect: (index) =>
                      setState(() => _selectedPaymentIndex = index),
                  walletLabel: _walletLabel,
                ),
                const SizedBox(height: 10),
                _CheckoutSection(
                  title: Strings.note.tr,
                  child: CustomTextField(
                    controller: _noteController,
                    hintText: Strings.writeYourNoteHere.tr,
                    maxLines: 4,
                  ),
                ),
                const SizedBox(height: 18),
                Obx(
                  () => PaymentSummaryCard(
                    items: _summaryItems,
                    total: _summaryTotal,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              text: Strings.placeOrder.tr,
              onPressed: _handlePlaceOrder,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _voucherController.removeListener(_handleVoucherChanged);
    _voucherController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}

class _CheckoutSection extends StatelessWidget {
  const _CheckoutSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2F2F2F),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
