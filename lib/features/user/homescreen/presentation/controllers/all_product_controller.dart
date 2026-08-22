import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/all_product_model.dart';
import 'package:hoodz/urls.dart';

class AllTrendingProductController extends GetxController {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final Rx<AllProductModel?> _productModel = Rx<AllProductModel?>(null);
  int _currentPage = 1;
  int _totalPage = 1;
  AllProductModel? get productModel => _productModel.value;
  List<AllProductItemModel> get products =>
      _productModel.value?.data ?? const [];
  bool get hasMoreDuas => _currentPage < _totalPage;

  @override
  void onInit() {
    super.onInit();
    getTrendingProduct();
  }

  final RxString title = ''.obs;
  final RxString image = ''.obs;

   void initialize(Map<String, dynamic>? arguments) {
    title.value = arguments?['title'] as String? ?? 'Men';
    image.value = arguments?['image'] as String? ?? '';
    
  }

  Future<void> getTrendingProduct({bool loadMore = false}) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return;
    }

    if (loadMore) {
      if (isLoading.value || isLoadingMore.value || !hasMoreDuas) {
        return;
      }
    } else {
      if (isLoading.value) {
        return;
      }

      _resetDuas();
    }

    final page = loadMore ? _currentPage + 1 : 1;

    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
    }

    try {
      final response = await _networkCaller.getRequest(
        Urls.trendingProductUrl,
        accessToken: accessToken,
        queryParams: {'page': page},
      );

      if (response.isSuccess) {
        final model = AllProductModel.fromJson(response.responseData);
        _currentPage = model.meta?.page ?? page;
        _totalPage = model.meta?.totalPage ?? _currentPage;

        if (loadMore && _productModel.value != null) {
          _productModel.value = AllProductModel(
            success: model.success,
            statusCode: model.statusCode,
            message: model.message,
            meta: model.meta,
            data: [..._productModel.value!.data, ...model.data],
          );
        } else {
          _productModel.value = model;
        }
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  void _resetDuas() {
    _currentPage = 1;
    _totalPage = 1;
    _productModel.value = null;
  }
}
