import 'package:flutter/material.dart';
import 'package:hoodz/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/profile_picture_setup_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/profile_setup_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/set_password_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/verify_email_screen.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/pages/ai_assistant_screen.dart';
import 'package:hoodz/features/user/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:hoodz/features/user/chat/presentation/pages/customer_support_message_screen.dart';
import 'package:hoodz/features/user/chat/presentation/pages/order_support_message_screen.dart';
import 'package:hoodz/features/user/product/presentation/pages/all_product_screen.dart';
import 'package:hoodz/features/user/product/presentation/pages/all_product_review_screen.dart';
import 'package:hoodz/features/user/product/presentation/pages/all_vouchers_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/all_brand_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/home_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/campaign_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/map_location_picker_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/search_screen.dart';
import 'package:hoodz/features/user/orders/presentation/pages/cart_screen.dart';
import 'package:hoodz/features/user/orders/presentation/pages/saved_delivery_location_screen.dart';
import 'package:hoodz/features/user/product/presentation/pages/product_details_screen.dart';
import 'package:hoodz/features/user/profile/presentation/pages/notification_screen.dart';
import 'package:hoodz/features/user/shop/presentation/pages/shop_details_screen.dart';
import 'package:hoodz/features/user/shop/presentation/pages/shop_product_screen.dart';
import 'package:hoodz/features/user/shop/presentation/pages/shop_screen.dart';
import 'package:hoodz/features/user/payment/presentation/pages/add_payment_screen.dart';
import 'package:hoodz/features/user/payment/presentation/pages/delivery_method_screen.dart';
import 'package:hoodz/features/user/payment/presentation/pages/payment_details_screen.dart';
import 'package:hoodz/features/user/payment/presentation/pages/payment_method_screen.dart';
import 'package:hoodz/features/user/payment/presentation/pages/payment_successfull_screen.dart';
import 'package:hoodz/features/user/payment/presentation/pages/shipping_information_screen.dart';
import 'package:hoodz/features/user/profile/presentation/pages/change_password_screen.dart';
import 'package:hoodz/features/user/profile/presentation/pages/content_screen.dart';
import 'package:hoodz/features/user/profile/presentation/pages/edit_profile_screen.dart';
import 'package:hoodz/features/user/orders/presentation/pages/points_screen.dart';
import 'package:hoodz/features/user/wishlist/presentation/pages/wishlist_screen.dart';

import '../../features/auth/presentation/pages/splash_screen.dart';
import 'app_routes.dart';
 
abstract final class AppPages {
  static String get initial => initialRoute;

  static final routes = <String, WidgetBuilder>{
    AppRoutes.splashScreen: (_) => const SplashScreen(),
    AppRoutes.signIn: (_) => const SignInScreen(),
    AppRoutes.signUp: (_) => const SignUpScreen(),
    AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
    AppRoutes.verifyEmail: (_) => const VerifyEmailScreen(),
    AppRoutes.setPassword: (_) => const SetPasswordScreen(),
    AppRoutes.profileSetup: (_) => const ProfileSetupScreen(),
    AppRoutes.profilePictureSetup: (_) => const ProfilePictureSetupScreen(),
    AppRoutes.userDashboard: (_) => const UserDashboardScreen(),

    AppRoutes.homeScreen: (_) => const HomeScreen(),
    AppRoutes.mapLocationPicker: (_) => const MapLocationPickerScreen(),
    AppRoutes.searchScreen: (_) => const SearchScreen(),
    AppRoutes.editProfile: (_) => const EditProfileScreen(),
    AppRoutes.changePassword: (_) => const ChangePasswordScreen(),
    AppRoutes.content: (_) => const ContentScreen(),
    AppRoutes.wishlist: (_) => const WishlistScreen(),
    AppRoutes.cart: (_) => const CartScreen(),
    AppRoutes.allProduct: (_) => const AllProductScreen(),
    AppRoutes.allProductReview: (_) => const AllProductReviewScreen(),
    AppRoutes.allVouchers: (_) => const AllVouchersScreen(),
    AppRoutes.allBrand: (_) => const AllBrandScreen(),
    AppRoutes.productDetails: (_) => const ProductDetailsScreen(),
    AppRoutes.shop: (_) => const ShopScreen(),
    AppRoutes.shopProduct: (_) => const ShopProductScreen(),
    AppRoutes.addPayment: (_) => const AddPaymentScreen(),
    AppRoutes.shippingInformation: (_) => const ShippingInformationScreen(),
    AppRoutes.savedDeliveryLocation: (_) => const SavedDeliveryLocationScreen(),
    AppRoutes.deliveryMethod: (_) => const DeliveryMethodScreen(),
    AppRoutes.paymentDetails: (_) => const PaymentDetailsScreen(),
    AppRoutes.paymentMethod: (_) => const PaymentMethodScreen(),
    AppRoutes.paymentSuccessfull: (_) => const PaymentSuccessfullScreen(),
    AppRoutes.aiAssistant: (_) => const AiAssistantScreen(),
    AppRoutes.campaign: (_) => const CampaignScreen(),
    AppRoutes.customerSupportMessage: (_) =>
        const CustomerSupportMessageScreen(),
    AppRoutes.orderSupportMessage: (_) => const OrderSupportMessageScreen(),
    AppRoutes.shopDetails: (_) => const ShopDetailsScreen(),
    AppRoutes.points: (_) => const PointsScreen(),
    AppRoutes.riderNotification: (_) => const NotificationScreen(),
    AppRoutes.notification: (_) => const NotificationScreen(),
  };
}
