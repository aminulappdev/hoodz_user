import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
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
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_initiate_controller.dart';
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

  Future<bool> _submitOrderSummary({required bool showConfirmPopup}) async {
    final note = _noteController.text.trim();
    final voucherCode = _voucherController.text.trim();
    final redeemCoins = _usePoints ? _availablePoints : null;

    final isSuccess = await _orderSummaryController.createOrderSummary(
      deliveryType: _selectedDeliveryType,
      voucherCode: voucherCode.isEmpty ? null : voucherCode,
      redeemCoins: redeemCoins == 0 ? null : redeemCoins,
      note: note.isEmpty ? null : note,
    );

    if (!isSuccess) {
      return false;
    }

    if (showConfirmPopup) {
      await _showConfirmOrderPopup();
    }

    return true;
  }

  Future<void> _handlePlaceOrder() async {
    await _submitOrderSummary(showConfirmPopup: true);
  }

  Future<void> _handleContinueOrder() async {
    final note = _noteController.text.trim();
    final voucherCode = _voucherController.text.trim();
    final redeemCoins = _usePoints ? _availablePoints : null;

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

    if (_selectedPaymentMethodValue == 'card') {
      final paymentData = _paymentInitiateController.cardPaymentData;
      final paymentUrl = paymentData?.paymentUrl;
      if (paymentUrl == null || paymentUrl.trim().isEmpty) {
        showAppToast(
          message: 'Payment URL not found. Please try again.',
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
          PageNavigationService.to(context, AppRoutes.paymentSuccessfull);
        },
      );
      return;
    }

    Navigator.of(context).pop();
    PageNavigationService.to(context, AppRoutes.paymentSuccessfull);
  }

  Future<void> _applyVoucherAndPoints() async {
    await _submitOrderSummary(showConfirmPopup: false);
  }

  List<SummaryItem> get _summaryItems {
    final data = _orderSummaryController.orderSummaryData;
    if (data == null) {
      return const [
        SummaryItem('Subtotal', '\$0.00'),
        SummaryItem('Discount', '-\$0.00'),
        SummaryItem('Delivery fee', '\$0.00'),
      ];
    }

    final items = <SummaryItem>[
      SummaryItem('Subtotal', _formatCurrency(data.amount)),
    ];

    final voucherDiscount = data.voucherDiscount ?? 0;
    if (voucherDiscount != 0) {
      items.add(
        SummaryItem('Voucher discount', '-${_formatCurrency(voucherDiscount)}'),
      );
    }

    final coinDiscount = data.coinDiscount ?? 0;
    if (coinDiscount != 0) {
      items.add(
        SummaryItem('Coin discount', '-${_formatCurrency(coinDiscount)}'),
      );
    }

    items.add(
      SummaryItem('Delivery fee', _formatCurrency(data.deliveryCharge)),
    );

    return items;
  }

  SummaryItem get _summaryTotal {
    final totalAmount = _orderSummaryController.orderSummaryData?.totalAmount;
    return SummaryItem('Total Amount', _formatCurrency(totalAmount));
  }

  int get _availablePoints =>
      _profileController.userData?.coins ??
      _profileController.userData?.balance ??
      0;

  String get _orderName {
    final billing = _orderSummaryController.orderSummaryData?.billingDetails;
    return billing?.name?.trim().isNotEmpty == true ? billing!.name! : 'N/A';
  }

  String get _orderPhone {
    final billing = _orderSummaryController.orderSummaryData?.billingDetails;
    return billing?.phoneNumber?.trim().isNotEmpty == true
        ? billing!.phoneNumber!
        : 'N/A';
  }

  String get _orderDeliveryType {
    final normalized = _selectedDeliveryType.trim().toLowerCase();
    return normalized == 'instant' ? 'Instant Delivery' : 'Regular Delivery';
  }

  String get _orderAddress {
    final billing = _orderSummaryController.orderSummaryData?.billingDetails;
    final pieces =
        <String>[?billing?.address, ?billing?.city, ?billing?.country]
            .where((part) => part != null && part!.trim().isNotEmpty)
            .map((part) => part!.trim())
            .toList();

    return pieces.isEmpty ? 'N/A' : pieces.join(', ');
  }

  String get _availablePointsLabel => 'Available points: $_availablePoints';

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

    return items.map((item) {
      final product = item.product;
      final name = product?.title?.trim().isNotEmpty == true
          ? product!.title!
          : (item.productId ?? 'Item');
      final imageUrl = product?.banner?.trim().isNotEmpty == true
          ? product!.banner
          : null;
      final price = item.unitPrice ?? item.totalPrice ?? 0;

      return OrderItem(
        name: name,
        size: item.size ?? 'N/A',
        quantity: item.quantity ?? 1,
        price: price.toDouble(),
        imageUrl: imageUrl,
      );
    }).toList(growable: false);
  }

  String _buildDeliveryAddress(order_summary.Data data) {
    final billing = data.billingDetails;
    final parts = <String>[
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
        : 'N/A';
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
      appBar: CustomAppBar(label: 'Checkout'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              children: [
                CheckoutOrderDetailsCard(
                  onChangeTap: () {
                    PageNavigationService.to(
                      context,
                      AppRoutes.shippingInformation,
                    );
                  },
                  name: _orderName,
                  phone: _orderPhone,
                  deliveryType: _orderDeliveryType,
                  address: _orderAddress,
                ),
                const SizedBox(height: 14),
                CheckoutVoucherPointsCard(
                  voucherController: _voucherController,
                  isPointsEnabled: _usePoints,
                  onPointsChanged: (value) {
                    setState(() {
                      _usePoints = value;
                    });
                  },
                  onApplyVoucher: _applyVoucherAndPoints,
                  availablePointsLabel: _availablePointsLabel,
                ),
                const SizedBox(height: 14),
                _CheckoutSection(
                  title: 'Delivery Type',
                  child: CustomTextField(
                    hintText: 'Select',
                    value: _selectedDeliveryType == 'regular'
                        ? 'Regular Delivery'
                        : 'Instant Delivery',
                    onChanged: (value) async {
                      final nextDeliveryType =
                          value == 'Instant Delivery' ? 'instant' : 'regular';

                      setState(() {
                        _selectedDeliveryType = nextDeliveryType;
                      });

                      await _submitOrderSummary(showConfirmPopup: false);
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: 'Regular Delivery',
                        child: Text(
                          'Regular Delivery',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 15.sp(context),
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Instant Delivery',
                        child: Text(
                          'Instant Delivery',
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
                ),
                const SizedBox(height: 10),
                _CheckoutSection(
                  title: 'Note',
                  child: CustomTextField(
                    controller: _noteController,
                    hintText: 'Write your note here...',
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
              text: 'Place Order',
              onPressed: _handlePlaceOrder,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
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
