import 'package:get/get.dart';
import 'package:hoodz/core/services/socket/socket_service.dart';
import 'package:hoodz/core/services/socket/user_order_socket_service.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/controller/ai_assistant_controller.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/chat_system_controller.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/customer_support_message_controller.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/general_message_controller.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/order_support_message_controller.dart';
import 'package:hoodz/features/user/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/address_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/ai_recommended_product_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_brand_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_controller.dart'
    as home_product;
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_info_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/campaign_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/product_details_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/search_screen_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/cart_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/customer_service_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/my_orders_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_details_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/orders_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/product_order_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/saved_location_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/add_payment_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/delivery_method_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_details_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_initiate_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_method_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_successfull_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_transaction_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/shipping_information_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/wallet_top_up_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/wallet_transaction_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_controller.dart'
    as product;
import 'package:hoodz/features/user/product/presentation/controller/all_product_review_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_vouchers_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/product_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/product_review_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/change_password_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/content_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/edit_profile_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/sho_connection_controoler.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_details_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_product_controller.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';

Future<void> clearLogoutSession() async {
  if (Get.isRegistered<UserOrderSocketService>()) {
    Get.find<UserOrderSocketService>().stopTracking();
  }

  if (Get.isRegistered<SocketService>()) {
    final socketService = Get.find<SocketService>();
    socketService.messageList.clear();
    socketService.disconnect();
  }

  if (Get.isRegistered<ProfileController>()) {
    Get.find<ProfileController>().clearUserProfile();
  }

  await MySharedPref.clear();

  _deleteIfRegistered<UserDashboardController>();
  _deleteIfRegistered<AddressController>();
  _deleteIfRegistered<HomeScreenController>();
  _deleteIfRegistered<SearchScreenController>();
  _deleteIfRegistered<AllBrandController>();
  _deleteIfRegistered<home_product.AllTrendingProductController>();
  _deleteIfRegistered<AllProductInfoController>();
  _deleteIfRegistered<CampaignController>();
  _deleteIfRegistered<AiRecommendedProductController>();
  _deleteIfRegistered<ProductDetailsController>();

  _deleteIfRegistered<CartController>();
  _deleteIfRegistered<OrderSummaryController>();
  _deleteIfRegistered<ProductOrderController>();
  _deleteIfRegistered<SavedLocationController>();
  _deleteIfRegistered<OrderDetailsController>();
  _deleteIfRegistered<CustomerServiceController>();
  _deleteIfRegistered<MyOrdersController>();
  _deleteIfRegistered<OrderController>();

  _deleteIfRegistered<product.AllProductController>();
  _deleteIfRegistered<ProductController>();
  _deleteIfRegistered<AllProductReviewController>();
  _deleteIfRegistered<AllVouchersController>();
  _deleteIfRegistered<ProductReviewController>();

  _deleteIfRegistered<ShopController>();
  _deleteIfRegistered<ShopDetailsController>();
  _deleteIfRegistered<ShopProductController>();
  _deleteIfRegistered<ShoConnectionControoler>();

  _deleteIfRegistered<AddPaymentController>();
  _deleteIfRegistered<ShippingInformationController>();
  _deleteIfRegistered<DeliveryMethodController>();
  _deleteIfRegistered<PaymentDetailsController>();
  _deleteIfRegistered<PaymentInitiateController>();
  _deleteIfRegistered<PaymentMethodController>();
  _deleteIfRegistered<PaymentSuccessfullController>();
  _deleteIfRegistered<PaymentTransactionController>();
  _deleteIfRegistered<WalletTopUpController>();
  _deleteIfRegistered<WalletTransactionController>();

  _deleteIfRegistered<ChatSystemController>();
  _deleteIfRegistered<GeneralMessageController>();
  _deleteIfRegistered<CustomerSupportMessageController>();
  _deleteIfRegistered<OrderSupportMessageController>();
  _deleteIfRegistered<AiAssistantController>();

  _deleteIfRegistered<WishlistController>();
  _deleteIfRegistered<ProfileController>();
  _deleteIfRegistered<EditProfileController>();
  _deleteIfRegistered<ChangePasswordController>();
  _deleteIfRegistered<ContentController>();
}

void _deleteIfRegistered<T>() {
  if (Get.isRegistered<T>()) {
    Get.delete<T>(force: true);
  }
}
