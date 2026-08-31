import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/product_details_model.dart'
    as product_details;
import 'package:hoodz/features/user/orders/data/models/my_cart_model.dart';
import 'package:hoodz/features/user/orders/data/models/cart_item_update_options.dart';
import 'package:hoodz/urls.dart';

class CartController extends GetxController {
  CartController(this._networkCaller);
  
  final NetworkCaller _networkCaller;
  final double deliveryCharge = 1.00;
  final RxBool isLoading = false.obs;
  final Rx<MyCartModel?> _cartModel = Rx<MyCartModel?>(null);

  MyCartModel? get cartModel => _cartModel.value;
  Data? get cartData => _cartModel.value?.data;
  List<Item> get cartItems => cartData?.items ?? const [];
  List<RecommendedProduct> get recommendedItems =>
      cartData?.recommendedProducts ?? const [];

  double get subTotal => (cartData?.subTotal ?? 0).toDouble();

  double get totalCost => subTotal + deliveryCharge;

  String get itemLabel =>
      '${cartItems.length} ${cartItems.length == 1 ? Strings.item.tr : Strings.items.tr}';

  @override
  void onInit() {
    super.onInit();
    getCartData();
  }

  Future<bool> addToCart({
    required String productId,
    String? size, 
    Map<String, String>? color,
    int quantity = 1,
  }) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return false;
    }

    if (productId.isEmpty) {
      showAppToast(message: Strings.productIdNotFound.tr, isError: true);
      return false;
    }

    bool isSuccess = false;

    await showLoadingOverLay(
      msg: Strings.addingToCart.tr,
      asyncFunction: () async {
        final body = <String, dynamic>{
          'productId': productId,
          'quantity': quantity,
        };

        final normalizedSize = size?.trim();
        if (normalizedSize != null && normalizedSize.isNotEmpty) {
          body['size'] = normalizedSize;
        }

        final colorCode = color?['code']?.trim();
        final colorName = color?['name']?.trim();
        if (colorCode != null &&
            colorCode.isNotEmpty &&
            colorName != null &&
            colorName.isNotEmpty) {
          body['color'] = {
            'code': colorCode,
            'name': colorName,
          };
        }

        final response = await _networkCaller.postRequest(
          Urls.cartAddUrl,
          accessToken: accessToken,
          body: body,
        );

        if (!response.isSuccess) {
          showAppToast(message: response.errorMessage, isError: true);
          return;
        }

        showAppToast(message: Strings.addToCartSuccess.tr);
        isSuccess = true;
      },
    );

    return isSuccess;
  }

  Future<bool> updateCartItem({
    required String productId,
    String? size,
    Map<String, String>? color,
    required int quantity,
  }) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return false;
    }

    if (productId.isEmpty) {
      showAppToast(message: Strings.productIdNotFound.tr, isError: true);
      return false;
    }

    bool isSuccess = false;

    await showLoadingOverLay(
      msg: Strings.updatingCart.tr,
      asyncFunction: () async {
        final body = <String, dynamic>{
          'productId': productId,
          'quantity': quantity,
        };

        final normalizedSize = size?.trim();
        if (normalizedSize != null && normalizedSize.isNotEmpty) {
          body['size'] = normalizedSize;
        }

        final colorCode = color?['code']?.trim();
        final colorName = color?['name']?.trim();
        if (colorCode != null &&
            colorCode.isNotEmpty &&
            colorName != null &&
            colorName.isNotEmpty) {
          body['color'] = {
            'code': colorCode,
            'name': colorName,
          };
        }
 
        final response = await _networkCaller.putRequest(
          Urls.cartUpdateUrl,
          accessToken: accessToken,
          body: body,
        );

        if (!response.isSuccess) {
          showAppToast(message: response.errorMessage, isError: true);
          return;
        }

        await getCartData();
        showAppToast(message: Strings.cartUpdatedSuccessfully.tr);
        isSuccess = true;
      },
    );

    return isSuccess;
  }

  Future<CartItemUpdateOptions?> fetchCartItemUpdateOptions({
    required String productId,
  }) async {
    try {
      final accessToken = MySharedPref.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        showAppToast(
          message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
          isError: true,
        );
        return null;
      }

      if (productId.isEmpty) {
        showAppToast(message: Strings.productIdNotFound.tr, isError: true);
        return null;
      }

      final response = await _networkCaller.getRequest(
        Urls.getProductUrlById(productId),
        accessToken: accessToken,
      );

      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return null;
      }

      final productDetails = product_details.ProductDetailsModel.fromJson(
        response.responseData,
      );
      final product = productDetails.data?.product;
      final inventoryType = _normalizeString(product?.inventoryType)?.toLowerCase();
      final variants = product?.variants ?? const <dynamic>[];

      final sizes = inventoryType == 'size_color'
          ? _extractUniqueSizes(variants)
          : const <String>[];
      final colors = inventoryType == 'single'
          ? const <CartColorOption>[]
          : _extractUniqueColors(variants);

      return CartItemUpdateOptions(sizes: sizes, colors: colors);
    } catch (e) {
      showAppToast(message: e.toString(), isError: true);
      return null;
    }
  }

  Future<void> getCartData() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return;
    }

    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await _networkCaller.getRequest(
        Urls.cartUrl,
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        _cartModel.value = MyCartModel.fromJson(response.responseData);
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void increaseQuantity(int index) {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    final item = cartItems[index];
    final quantity = (item.quantity ?? 1) + 1;
    updateCartItem(
      productId: item.productId ?? '',
      size: item.size,
      color: item.color == null
          ? null
          : {
              'code': item.color?.code ?? '',
              'name': item.color?.name ?? '',
            },
      quantity: quantity,
    );
  }

  void decreaseQuantity(int index) {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    final item = cartItems[index];
    final currentQuantity = item.quantity ?? 1;
    if (currentQuantity <= 1) {
      return;
    }

    updateCartItem(
      productId: item.productId ?? '',
      size: item.size,
      color: item.color == null
          ? null
          : {
              'code': item.color?.code ?? '',
              'name': item.color?.name ?? '',
      },
      quantity: currentQuantity - 1,
    );
  }

  Future<bool> removeCartItem({
    required String productId,
    String? size,
    Map<String, String>? color,
  }) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return false;
    }

    if (productId.isEmpty) {
      showAppToast(message: Strings.productIdNotFound.tr, isError: true);
      return false;
    }

    bool isSuccess = false;

    await showLoadingOverLay(
      msg: Strings.removingItem.tr,
      asyncFunction: () async {
        final body = <String, dynamic>{
          'productId': productId,
        };

        final normalizedSize = size?.trim();
        if (normalizedSize != null && normalizedSize.isNotEmpty) {
          body['size'] = normalizedSize;
        }

        final colorCode = color?['code']?.trim();
        final colorName = color?['name']?.trim();
        if (colorCode != null &&
            colorCode.isNotEmpty &&
            colorName != null &&
            colorName.isNotEmpty) {
          body['color'] = {
            'code': colorCode,
            'name': colorName,
          };
        }

        final response = await _networkCaller.deleteRequest(
          Urls.cartRemoveUrl,
          accessToken: accessToken,
          body: body,
        );

        if (!response.isSuccess) {
          showAppToast(message: response.errorMessage, isError: true);
          return;
        }

        await getCartData();
        showAppToast(message: Strings.itemRemovedFromCart.tr);
        isSuccess = true;
      },
    );

    return isSuccess;
  }

  Future<void> removeItem(int index) async {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    final item = cartItems[index];
    await removeCartItem(
      productId: item.productId ?? item.product?.id ?? '',
      size: item.size,
      color: item.color == null
          ? null
          : {
              'code': item.color?.code ?? '',
              'name': item.color?.name ?? '',
            },
    );
  }

  String cartItemImage(Item item) {
    return item.product?.banner ?? AppStrings.demoImageUrl;
  }

  String cartItemName(Item item) {
    return item.product?.title ?? Strings.unnamedProduct.tr;
  }

  String cartItemSize(Item item) {
    final size = item.size?.trim();
    return (size == null || size.isEmpty) ? Strings.notAvailable.tr : size;
  }

  String cartItemColor(Item item) {
    final colorName = item.color?.name?.trim();
    return (colorName == null || colorName.isEmpty)
        ? Strings.notAvailable.tr
        : colorName;
  }

  double cartItemPrice(Item item) {
    return (item.unitPrice ?? item.totalPrice ?? 0).toDouble();
  }

  String recommendedImage(RecommendedProduct item) {
    return item.banner ?? AppStrings.demoImageUrl;
  }

  String recommendedName(RecommendedProduct item) {
    return item.title ?? Strings.unnamedProduct.tr;
  }

  List<String> _extractUniqueSizes(List<dynamic> variants) {
    final sizes = <String>[];
    for (final variant in variants) {
      final size = variant?.size?.toString().trim();
      if (size != null && size.isNotEmpty && !sizes.contains(size)) {
        sizes.add(size);
      }
    }
    return sizes;
  }

  List<CartColorOption> _extractUniqueColors(
    List<dynamic> variants,
  ) {
    final colors = <CartColorOption>[];
    final seen = <String>{};

    for (final variant in variants) {
      final color = variant?.color;
      final code = color?.code?.toString().trim() ?? '';
      final name = color?.name?.toString().trim() ?? '';
      if (code.isEmpty || name.isEmpty) {
        continue;
      }

      final key = '$code|$name';
      if (seen.add(key)) {
        colors.add(CartColorOption(code: code, name: name));
      }
    }

    return colors;
  }

  String? _normalizeString(dynamic value) {
    final normalized = value?.toString().trim();
    return (normalized == null || normalized.isEmpty) ? null : normalized;
  }
}
