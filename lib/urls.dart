class Urls {
  static const String _baseUrl = 'http://72.244.153.29:5029/api/v1';
  static const String socketUrl = 'http://72.244.153.29:5029';

  static const String signUpWithEmailUrl = '$_baseUrl/auth/signup-with-email';
  static const String loginWithEmailUrl = '$_baseUrl/auth/login-with-email';
  static const String forgotPasswordUrl = '$_baseUrl/auth/forgot-password';
  static const String verifyOtpUrl = '$_baseUrl/otp/verify';
  static const String resetPasswordUrl = '$_baseUrl/auth/reset-password';
  static const String changePasswordUrl = '$_baseUrl/auth/change-password';
  static const String uploadMultipleUrl = '$_baseUrl/upload/multiple';
  static const String currentUserUrl = '$_baseUrl/users/me';
  static const String referralCodeUrl = '$_baseUrl/users/referral-code';
  static const String userLocationUrl = '$_baseUrl/users/location';
  static const String deliveryLocationUrl = '$_baseUrl/users/delivery-location';
  static const String savedLocationsUrl = '$_baseUrl/saved-locations';
  static const String settingsUrl = '$_baseUrl/settings';
  static const String searchUrl = '$_baseUrl/search';
  static const String searchDataUrl = '$_baseUrl/search/data';
  static const String searchProductsUrl = '$_baseUrl/products';
  static const String searchFilterPageDataUrl =
      '$_baseUrl/search/filter-page-data';
  static const String cartUrl = '$_baseUrl/cart';
  static const String cartAddUrl = '$_baseUrl/cart/add';
  static const String cartUpdateUrl = '$_baseUrl/cart/update';
  static const String cartRemoveUrl = '$_baseUrl/cart/remove';
  static const String orderSummaryUrl = '$_baseUrl/orders/summary';
  static const String orderUrl = '$_baseUrl/orders';
  static const String myOrdersUrl = '$_baseUrl/orders/my-orders';
  static String getOrderDetailsUrlById(String id) => '$_baseUrl/orders/$id';
  static const String paymentInitiateUrl = '$_baseUrl/payments/initiate';
  static const String paymentTransactionsUrl =
      '$_baseUrl/payments/user/transctions';
  static const String chatUrl = '$_baseUrl/chat';
  static const String grievanceUrl = '$_baseUrl/grievance';
  static const String reviewsUrl = '$_baseUrl/reviews';
  static String getProductReviewsUrlById(String id) {
    return '$_baseUrl/reviews/product/$id';
  }
  static String getChatMessagesUrlById(String chatId) =>
      '$_baseUrl/messages/chat/$chatId';
  static const String aiAssistantMessagesUrl =
      '$_baseUrl/messages/ai-assistant';
  static const String walletTopUpUrl = '$_baseUrl/top-up/add-wallet-money';
  static const String walletTransactionsUrl = '$_baseUrl/wallet-transactions';
  static const String kycUrl = '$_baseUrl/kyc';
  static const String metaUserUrl = '$_baseUrl/meta/user';
  static String metaUserGuestUrl({
    required double lat,
    required double lng,
  }) {
    return '$_baseUrl/meta/user/guest?lat=$lat&lng=$lng';
  }

  static const String trendingProductUrl = '$_baseUrl/products/trending';
  static const String aiRecommendedProductUrl =
      '$_baseUrl/products/ai-recommended';
  static const String campaignUrl = '$_baseUrl/campain';
  static String getBrandTypeCategoriesUrl(String brandType) {
    return '$_baseUrl/category/brand-type?brandType=$brandType';
  }

  static String getCategoryShopsUrl(String categoryId) {
    return '$_baseUrl/category/$categoryId/shops';
  }

  static String getProductUrlById(String id) {
    return '$_baseUrl/products/$id';
  }

  static String getProductViewedUrlById(String id) {
    return '$_baseUrl/products/viewed/$id';
  }

  static String getShopDetailsUrlById(String id) {
    return '$_baseUrl/users/shops/$id/details';
  }

  static String getShopProductsUrlById(String id) {
    return '$_baseUrl/products/shop/$id';
  }

  static String getShopFollowUrlById(String id) {
    return '$_baseUrl/connections/follow/$id';
  }

  static String getShopUnfollowUrlById(String id) {
    return '$_baseUrl/connections/unfollow/$id';
  }

  static String getWishlistToggleUrlById(String id) {
    return '$_baseUrl/wishlist/toggle/$id';
  }

  static String getWishlistUrlById(String id) {
    return '$_baseUrl/wishlist/$id';
  }

  static const String wishlistUrl = '$_baseUrl/wishlist';
}
