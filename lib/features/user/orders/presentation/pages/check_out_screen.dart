import 'package:flutter/material.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/orders/data/models/payment_model.dart';
import 'package:hoodz/features/user/orders/presentation/pages/check_out_popup.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_delivery_status_card.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_map_card.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_order_details_card.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/payment_summary_card.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/play_with_card.dart';

const Color kBgGrey = Color(0xFFF6F6F8);

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentIndex = 0;

  final List<PaymentMethod> _paymentMethods = const [
    PaymentMethod(
      type: 'PayPal',
      maskedNumber: '2350 **** **** **45',
      expiry: '03/30',
    ),
    PaymentMethod(
      type: 'PayPal',
      maskedNumber: '2350 **** **** **45',
      expiry: '03/30',
    ),
    PaymentMethod(
      type: 'PayPal',
      maskedNumber: '2350 **** **** **45',
      expiry: '03/30',
    ),
  ];

  final List<OrderItem> _orderItems = const [
    OrderItem(
      imageUrl: AppStrings.demoImageUrl,
      name: 'Classic Black Blazer',
      size: 'M',
      quantity: 2,
      price: 240,
    ),
    OrderItem(
      imageUrl: AppStrings.demoImageUrl,
      name: 'Classic Black Blazer',
      size: 'M',
      quantity: 2,
      price: 240,
    ),
    OrderItem(
      imageUrl: AppStrings.demoImageUrl,
      name: 'Classic Black Blazer',
      size: 'M',
      quantity: 2,
      price: 240,
    ),
  ];

  void _handlePlaceOrder() {
    showConfirmOrderSheet(
      context,
      deliveryAddress: 'House 12, Road 5, Mohakhali, Dhaka',
      items: _orderItems,
      onContinue: () {
        PageNavigationService.to(context, AppRoutes.paymentSuccessfull);
      },
      onEditOrder: () {
        Navigator.of(context).pop(); // close the sheet
        // Real app: pop back to cart/checkout so the user can edit items.
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
                const CheckoutMapCard(
                  pickedUpLabel: 'Picked up',
                  riderLabel: 'Rider',
                ),
                const SizedBox(height: 4),
                CheckoutOrderDetailsCard(
                  onChangeTap: () {
                    PageNavigationService.to(
                      context,
                      AppRoutes.shippingInformation,
                    );
                  },
                ),
                const SizedBox(height: 14),
                const CheckoutDeliveryStatusCard(),
                const SizedBox(height: 20),
                PayWithSection(
                  methods: _paymentMethods,
                  selectedIndex: _selectedPaymentIndex,
                  onSelect: (index) =>
                      setState(() => _selectedPaymentIndex = index),
                  onAddCard: () {
                    PageNavigationService.to(context, AppRoutes.addPayment);
                  },
                ),
                const SizedBox(height: 18),
                PaymentSummaryCard(
                  items: const [
                    SummaryItem('Subtotal', '\$2,045.00'),
                    SummaryItem('Discount', '-\$204.50'),
                    SummaryItem('Delivery fee', '\$100.00'),
                    SummaryItem('Service fee', '\$8.00'),
                  ],
                  total: const SummaryItem('Total Amount', '\$656.02'),
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
}
