class Urls {
  static const String _baseUrl = 'http://72.244.153.29:5029/api/v1';

  static const String signUpWithEmailUrl = '$_baseUrl/auth/signup-with-email';
  static const String loginWithEmailUrl = '$_baseUrl/auth/login-with-email';
  static const String forgotPasswordUrl = '$_baseUrl/auth/forgot-password';
  static const String verifyOtpUrl = '$_baseUrl/otp/verify';
  static const String resetPasswordUrl = '$_baseUrl/auth/reset-password';
  static const String uploadMultipleUrl = '$_baseUrl/upload/multiple';
  static const String currentUserUrl = '$_baseUrl/users/me';
  static const String userLocationUrl = '$_baseUrl/users/location';
  static const String kycUrl = '$_baseUrl/kyc';
  static const String metaUserUrl = '$_baseUrl/meta/user';
  static const String trendingProductUrl = '$_baseUrl/products/trending';
  static const String aiRecommendedProductUrl =
      '$_baseUrl/products/ai-recommended';
  static String getBrandTypeCategoriesUrl(String brandType) {
    return '$_baseUrl/category/brand-type?brandType=$brandType';
  }

  static String getCategoryShopsUrl(String categoryId) {
    return '$_baseUrl/category/$categoryId/shops';
  }

  static String getProductUrlById(String id) {
    return '$_baseUrl/products/$id';
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
}
