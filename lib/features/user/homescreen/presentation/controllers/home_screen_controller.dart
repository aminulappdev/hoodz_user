import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/home_data_model.dart';
import 'package:hoodz/gen/assets.gen.dart';
import 'package:hoodz/urls.dart';
 
class HomeScreenController extends GetxController {
  HomeScreenController(this._locationService);

  final LocationSelectionService _locationService;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt notificationCount = 3.obs;
  final RxString selectedAddress = 'AQUA Tower, 43 Mohakhali C/A'.obs;
  final RxBool isLoadingCurrentLocation = false.obs;
 
  final List<Map<String, String>> categoryList = [
    {'image': Assets.icons.egypt.keyName, 'name': 'Local Brand'}, 
    {
      'image': Assets.icons.international.keyName,
      'name': 'International Brand',
    },
    {'image': Assets.icons.trendingNow.keyName, 'name': 'Trending Now'},
    {'image': Assets.icons.egypt.keyName, 'name': 'New Arrivals'},
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
      'name': 'Classic Black T-Shirt',
      'price': '\$45.00',
      'oldPrice': '\$50',
      'rating': '4.7',
      'subtitle': 'Women',
      'stockLabel': 'In Stock',
      'category': 'Men',
      'brand': 'Nike',
      'color': 'Black',
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

  Future<void> getUserMeta() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return;
    }

    if (isLoading.value) {
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
        notificationCount.value = homeData?.unreadNotification ?? 0;
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
