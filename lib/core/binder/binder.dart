import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/services/referral/referral_service.dart';
import 'package:hoodz/core/services/upload_service.dart';
import 'package:hoodz/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:hoodz/features/auth/presentation/controllers/profile_setup_controller.dart';
import 'package:hoodz/features/auth/presentation/controllers/set_password_controller.dart';
import 'package:hoodz/features/auth/presentation/controllers/sign_in_controller.dart';
import 'package:hoodz/features/auth/presentation/controllers/sign_up_controller.dart';
import 'package:hoodz/features/auth/presentation/controllers/verify_email_controller.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/controller/ai_assistant_controller.dart';
import 'package:hoodz/features/user/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/address_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/ai_recommended_product_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_brand_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_info_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/campaign_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/product_details_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/search_screen_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/cart_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/customer_service_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_details_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/product_order_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/saved_location_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/my_orders_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_review_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_vouchers_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/product_review_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/orders_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/product_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_details_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_product_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/sho_connection_controoler.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/add_payment_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/delivery_method_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_details_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_initiate_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_method_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_successfull_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_transaction_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/wallet_top_up_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/wallet_transaction_controller.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/chat_system_controller.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/customer_support_message_controller.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/general_message_controller.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/order_support_message_controller.dart';
import 'package:hoodz/core/services/socket/socket_service.dart';
import 'package:hoodz/core/services/socket/user_order_socket_service.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/shipping_information_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/change_password_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/content_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/edit_profile_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/notification_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkCaller());
    Get.put(UploadService(Get.find<NetworkCaller>()));
    Get.put(LocationSelectionService());
    Get.put(ReferralService(Get.find<NetworkCaller>()));
    Get.lazyPut(() => SignInController(Get.find<NetworkCaller>()), fenix: true);
    Get.lazyPut(() => SignUpController(Get.find<NetworkCaller>()), fenix: true);
    Get.lazyPut(
      () => ForgotPasswordController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(
      () => VerifyEmailController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SetPasswordController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ProfileSetupController(
        Get.find<LocationSelectionService>(),
        Get.find<NetworkCaller>(),
      ),
      fenix: true,
    );
    Get.lazyPut(UserDashboardController.new, fenix: true);
    Get.lazyPut(
      () => AddressController(
        Get.find<LocationSelectionService>(),
        Get.find<NetworkCaller>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => HomeScreenController(Get.find<LocationSelectionService>()),
      fenix: true,
    );
    Get.lazyPut(SearchScreenController.new, fenix: true);
    Get.lazyPut(
      () => AllBrandController(
        Get.find<HomeScreenController>(),
        Get.find<LocationSelectionService>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => AllProductController(Get.find<HomeScreenController>()),
      fenix: true,
    );
    Get.lazyPut(AllProductReviewController.new, fenix: true);
    Get.lazyPut(AllVouchersController.new, fenix: true);
    Get.lazyPut(() => CartController(Get.find<NetworkCaller>()), fenix: true);
    Get.lazyPut(OrderSummaryController.new, fenix: true);
    Get.lazyPut(ProductOrderController.new, fenix: true);
    Get.lazyPut(SavedLocationController.new, fenix: true);
    Get.lazyPut(OrderDetailsController.new, fenix: true);
    Get.lazyPut(
      () => CustomerServiceController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(MyOrdersController.new, fenix: true);
    Get.lazyPut(OrderController.new, fenix: true);
    Get.lazyPut(ProductController.new, fenix: true);
    Get.lazyPut(ShopController.new, fenix: true);
    Get.lazyPut(AddPaymentController.new, fenix: true);
    Get.lazyPut(
      () => ShippingInformationController(
        Get.find<LocationSelectionService>(),
        Get.find<NetworkCaller>(),
      ),
      fenix: true,
    );
    Get.lazyPut(DeliveryMethodController.new, fenix: true);
    Get.lazyPut(PaymentDetailsController.new, fenix: true);
    Get.lazyPut(PaymentInitiateController.new, fenix: true);
    Get.lazyPut(PaymentMethodController.new, fenix: true);
    Get.lazyPut(PaymentSuccessfullController.new, fenix: true);
    Get.lazyPut(PaymentTransactionController.new, fenix: true);
    Get.lazyPut(WalletTopUpController.new, fenix: true);
    Get.lazyPut(WalletTransactionController.new, fenix: true);
    Get.put(SocketService());
    Get.put(UserOrderSocketService(Get.find<SocketService>()));
    Get.lazyPut(
      () => ChatSystemController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GeneralMessageController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(
      () => CustomerSupportMessageController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(
      () => OrderSupportMessageController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(
      () => WishlistController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(ProfileController.new, fenix: true);
    Get.lazyPut(
      () => EditProfileController(
        Get.find<LocationSelectionService>(),
        Get.find<NetworkCaller>(),
        Get.find<ProfileController>(),
      ),
      fenix: true,
    );
    Get.lazyPut(ChangePasswordController.new, fenix: true);
    Get.lazyPut(NotificationController.new, fenix: true);
    Get.lazyPut(ContentController.new, fenix: true);
    Get.lazyPut(
      () => AiAssistantController(Get.find<NetworkCaller>()),
      fenix: true,
    );
    Get.lazyPut(CampaignController.new, fenix: true);
    Get.lazyPut(AllTrendingProductController.new, fenix: true);
    Get.lazyPut(AiRecommendedProductController.new, fenix: true);
    Get.lazyPut(AllProductInfoController.new, fenix: true);
    Get.lazyPut(ProductDetailsController.new, fenix: true);
    Get.lazyPut(ProductReviewController.new, fenix: true);
    Get.lazyPut(ShopDetailsController.new, fenix: true);
    Get.lazyPut(ShopProductController.new, fenix: true);
    Get.lazyPut(ShoConnectionControoler.new, fenix: true);
  }
}
