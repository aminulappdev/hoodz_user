import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/home_data_model.dart';
import 'package:hoodz/urls.dart';
import 'package:hoodz/gen/assets.gen.dart';

class HomeScreenController extends GetxController {  
  HomeScreenController(this._locationService);

  final LocationSelectionService _locationService; 
  final RxInt currentBannerIndex = 0.obs;
  final RxInt notificationCount = 3.obs;
  final RxString selectedAddress = 'AQUA Tower, 43 Mohakhali C/A'.obs;
  final RxBool isLoadingCurrentLocation = false.obs;

  final List<Map<String, String>> categoryList = [
    {
      'image': Assets.icons.egypt.keyName,
      'name': Strings.localBrand,
      'nameKey': Strings.localBrand,
    },
    {
      'image': Assets.icons.international.keyName,
      'name': Strings.internationalBrand,
      'nameKey': Strings.internationalBrand,
    },
    {
      'image': Assets.icons.trendingNow.keyName,
      'name': Strings.trendingNow,
      'nameKey': Strings.trendingNow,
    },
    {
      'image': Assets.icons.egypt.keyName,
      'name': Strings.newArrivals,
      'nameKey': Strings.newArrivals,
    },
  ];

  final List<Map<String, String>> brandList = [
    {'image': Assets.icons.brand01.path},
    {'image': Assets.icons.brans02.path},
    {'image': Assets.icons.brand03.path},
    {'image': Assets.icons.brand01.path},
    {'image': Assets.icons.brans02.path},
    {'image': Assets.icons.brand03.path},
  ];

  final List<Map<String, String>> productList = [
    {
      'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
      'name': Strings.classicBlackTShirt,
      'price': '\$45.00',
      'oldPrice': '\$50',
      'rating': '4.7',
      'subtitle': Strings.women,
      'stockLabel': Strings.inStock,
      'category': Strings.men,
      'brand': Strings.nike,
      'color': Strings.black,
      'size': 'M',
      'isFavorite': 'false',
      'imageUrl':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
    },
  ];

  final List<Map<String, String>> bannerList = [
    {'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b'},
    {'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8'},
    {'image': 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b'},
  ];

  @override
  void onInit() {
    super.onInit();
    getUserMeta();
  }

  void updateBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  Future<void> useCurrentLocation() async {
    isLoadingCurrentLocation.value = true;
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      selectedAddress.value = currentLocation.fullAddress;
    } finally {
      isLoadingCurrentLocation.value = false;
    }
  }
 
  void updateSelectedLocation(LocationAddress location) {
    selectedAddress.value = location.fullAddress;
  }

  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();
  final RxBool isLoading = false.obs;

  final Rx<HomeDataModel?> _homeDataModel = Rx<HomeDataModel?>(null);

  HomeDataModel? get homeDataModel => _homeDataModel.value;
  Data? get homeData => _homeDataModel.value?.data;

  void updateWishlistStatus({
    required String productId,
    required bool isWishlisted,
  }) {
    final currentModel = _homeDataModel.value;
    final currentData = currentModel?.data;

    if (currentModel == null || currentData == null) {
      return;
    }

    List<Product> updateProducts(List<Product> products) {
      return products
          .map(
            (product) => product.id == productId
                ? product.copyWith(isWishlisted: isWishlisted)
                : product,
          )
          .toList();
    }

    _homeDataModel.value = currentModel.copyWith(
      data: currentData.copyWith(
        recentlyViwed: updateProducts(currentData.recentlyViwed),
        trandingProducts: updateProducts(currentData.trandingProducts),
        aiRecommandedProducts: updateProducts(currentData.aiRecommandedProducts),
      ),
    );
  }

  Future<void> getUserMeta({bool force = false}) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return;
    }

    if (isLoading.value && !force) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await _networkCaller.getRequest(
        Urls.metaUserUrl,
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        _homeDataModel.value = HomeDataModel.fromJson(response.responseData);
        notificationCount.value = _toInt(homeData?.unreadNotification) ?? 0;
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
