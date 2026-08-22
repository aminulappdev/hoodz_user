import 'package:hoodz/core/utils/share_preference.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/profile_picture_setup_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/profile_setup_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/set_password_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:hoodz/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/pages/ai_assistant_screen.dart';
import 'package:hoodz/features/user/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:hoodz/features/user/product/presentation/pages/all_product_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/all_brand_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/home_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/map_location_picker_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/search_screen.dart';
import 'package:hoodz/features/user/orders/presentation/pages/cart_screen.dart';
import 'package:hoodz/features/user/product/presentation/pages/product_details_screen.dart';
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
import 'package:hoodz/features/user/product/presentation/pages/all_product_review_screen.dart';
import 'package:hoodz/features/user/product/presentation/pages/all_vouchers_screen.dart';
import 'package:hoodz/features/user/wishlist/presentation/pages/wishlist_screen.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';

abstract final class AppRoutes {
  static const splashScreen = '/splash';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const verifyEmail = '/verify-email';
  static const setPassword = '/set-password';
  static const vehicleDocument = '/vehicle-document';
  static const vehicleInformation = '/vehicle-information';
  static const profileSetup = '/profile-setup';
  static const profilePictureSetup = '/profile-picture-setup';
  static const userDashboard = '/user-dashboard';
  static const riderDashboard = '/rider-dashboard';
  static const riderDeliveryDetails = '/rider-delivery-details';
  static const riderDeliverySuccess = '/rider-delivery-success';
  static const riderCompletedDeliveryDetails =
      '/rider-completed-delivery-details';
  static const riderNotification = '/rider-notification';
  static const homeScreen = '/home-screen';
  static const mapLocationPicker = '/map-location-picker';
  static const searchScreen = '/search-screen';
  static const editProfile = '/edit-profile';
  static const changePassword = '/change-password';
  static const content = '/content';
  static const wishlist = '/wishlist';
  static const cart = '/cart';
  static const allProduct = '/all-product';
  static const allProductReview = '/all-product-review';
  static const allVouchers = '/all-vouchers';
  static const allBrand = '/all-brand';
  static const productDetails = '/product-details';
  static const shop = '/shop';
  static const addPayment = '/add-payment';
  static const shippingInformation = '/shipping-information';
  static const deliveryMethod = '/delivery-method';
  static const paymentDetails = '/payment-details';
  static const paymentMethod = '/payment-method';
  static const paymentSuccessfull = '/payment-successfull';
  static const aiAssistant = '/ai-assistant';
}

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    AppRoutes.splashScreen: (_) => const SplashScreen(),
    AppRoutes.signIn: (_) => const SignInScreen(),
    AppRoutes.signUp: (_) => const SignUpScreen(),
    AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
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
    AppRoutes.addPayment: (_) => const AddPaymentScreen(),
    AppRoutes.shippingInformation: (_) => const ShippingInformationScreen(),
    AppRoutes.deliveryMethod: (_) => const DeliveryMethodScreen(),
    AppRoutes.paymentDetails: (_) => const PaymentDetailsScreen(),
    AppRoutes.paymentMethod: (_) => const PaymentMethodScreen(),
    AppRoutes.paymentSuccessfull: (_) => const PaymentSuccessfullScreen(),
    AppRoutes.aiAssistant: (_) => const AiAssistantScreen(),
  };
}

String get initialRoute => MySharedPref.getAccessToken() != null
    ? AppRoutes.splashScreen
    : AppRoutes.splashScreen;
