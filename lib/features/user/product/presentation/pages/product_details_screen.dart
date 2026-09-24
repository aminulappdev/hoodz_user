import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/services/others/image_preview_service.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/label_container.dart';
import 'package:hoodz/core/widgets/shimmer/product_details_shimmer.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/product_details_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/view_all.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/cart_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/payment/presentation/models/voucher_model.dart';
import 'package:hoodz/features/user/payment/presentation/pages/voucher_screen.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/voucher_card_design.dart';
import 'package:hoodz/features/user/product/data/models/feedback_model.dart';
import 'package:hoodz/features/user/product/presentation/controller/product_review_controller.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_review_bottom_sheet.dart';
import 'package:hoodz/features/user/product/presentation/widgets/feedback_section.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/features/user/orders/presentation/pages/check_out_screen.dart';
import 'package:hoodz/features/user/product/presentation/widgets/card_buy_button.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/color_plate.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_policy_section.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_info.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/size_plate.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_vouchers_controller.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:hoodz/gen/assets.gen.dart'; 
 
class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsController controller =
      Get.find<ProductDetailsController>();
  bool _showFloatingCartButton = false;

  bool _hasAccessToken() =>
      MySharedPref.getAccessToken()?.trim().isNotEmpty == true;

  Color? _parseColor(dynamic value) { 
    if (value is Color) { 
      return value;
    } 

    if (value is int) {
      return Color(value);
    }

    if (value is String) {
      var hex = value.trim().replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      if (hex.length == 8) {
        final parsed = int.tryParse(hex, radix: 16);
        if (parsed != null) {
          return Color(parsed);
        }
      }
    }

    return null;
  }

  Map<String, String>? _resolveSelectedColorPayload({
    required List<dynamic> rawColors,
    required int selectedIndex,
  }) {
    if (selectedIndex < 0 || selectedIndex >= rawColors.length) {
      return null;
    }

    final selectedColor = rawColors[selectedIndex];

    if (selectedColor is Map<String, dynamic>) {
      final code = selectedColor['code']?.toString().trim();
      final name = selectedColor['name']?.toString().trim();
      if (code != null && code.isNotEmpty && name != null && name.isNotEmpty) {
        return {'code': code, 'name': name};
      }
    }

    if (selectedColor is Map) {
      final colorMap = Map<String, dynamic>.from(selectedColor);
      final code = colorMap['code']?.toString().trim();
      final name = colorMap['name']?.toString().trim();
      if (code != null && code.isNotEmpty && name != null && name.isNotEmpty) {
        return {'code': code, 'name': name};
      }
    }

    return null;
  } 

  Future<void> _showImagePreview({
    required BuildContext context,
    required List<String> images,
    int initialIndex = 0,
  }) async {
    await ImagePreviewService.show(
      context: context,
      images: images,
      initialIndex: initialIndex,
    );
  }

  List<String> _buildPreviewImages({
    required String? banner,
    required List<String> images,
  }) {
    final normalizedBanner = _normalizeString(banner);
    final previewImages = <String>[
      if (normalizedBanner != null) normalizedBanner,
      ...images
          .map(_normalizeString)
          .whereType<String>()
          .where((image) => image.isNotEmpty),
    ];

    return previewImages.toSet().toList(growable: false);
  }

  int _previewIndexForUrl({
    required List<String> previewImages,
    required String imageUrl,
  }) {
    final index = previewImages.indexOf(imageUrl);
    return index < 0 ? 0 : index;
  }

  String? _normalizeString(dynamic value) {
    final normalized = value?.toString().trim();
    return (normalized == null || normalized.isEmpty) ? null : normalized;
  }

  String? _extractVariantSize(dynamic variant) {
    if (variant is Map) {
      return _normalizeString(Map<String, dynamic>.from(variant)['size']);
    }

    return null;
  }

  Map<String, String>? _extractVariantColor(dynamic variant) {
    if (variant is! Map) {
      return null;
    }

    final colorValue = Map<String, dynamic>.from(variant)['color'];
    if (colorValue is Map<String, dynamic>) {
      final code = _normalizeString(colorValue['code']);
      final name = _normalizeString(colorValue['name']);
      if (code != null && name != null) {
        return {'code': code, 'name': name};
      }
    }

    if (colorValue is Map) {
      final colorMap = Map<String, dynamic>.from(colorValue);
      final code = _normalizeString(colorMap['code']);
      final name = _normalizeString(colorMap['name']);
      if (code != null && name != null) {
        return {'code': code, 'name': name};
      }
    }

    return null;
  }

  bool _variantMatchesSelection({
    required dynamic variant,
    required String? selectedSize,
    required Map<String, String>? selectedColor,
  }) {
    final variantSize = _extractVariantSize(variant);
    final variantColor = _extractVariantColor(variant);

    if (selectedSize != null) {
      if (variantSize == null || variantSize != selectedSize) {
        return false;
      }
    }

    if (selectedColor != null) {
      if (variantColor == null) {
        return false;
      }

      if (variantColor['code'] != selectedColor['code'] ||
          variantColor['name'] != selectedColor['name']) {
        return false;
      }
    }

    return true;
  }

  _ResolvedProductSelection _resolveProductSelection({
    required dynamic product,
    required List<String> sizeOptions,
    required List<dynamic> rawColors,
    required String selectedSize,
    required int selectedColorIndex,
  }) {
    final inventoryType = _normalizeString(
      product?.inventoryType,
    )?.toLowerCase();
    if (inventoryType == 'single') {
      return const _ResolvedProductSelection();
    }

    final normalizedSize = sizeOptions.isNotEmpty
        ? _normalizeString(selectedSize)
        : null;
    final selectedColor = _resolveSelectedColorPayload(
      rawColors: rawColors,
      selectedIndex: selectedColorIndex,
    );
    final variants = (product?.variants as List<dynamic>? ?? const <dynamic>[])
        .where((variant) => variant is Map)
        .toList(growable: false);

    if (variants.isNotEmpty) {
      dynamic matchedVariant;
      for (final variant in variants) {
        if (_variantMatchesSelection(
          variant: variant,
          selectedSize: normalizedSize,
          selectedColor: selectedColor,
        )) {
          matchedVariant = variant;
          break;
        }
      }

      matchedVariant ??= variants.first;

      final resolvedSize =
          _extractVariantSize(matchedVariant) ??
          normalizedSize ??
          (sizeOptions.isNotEmpty ? sizeOptions.first : null);
      final resolvedColor =
          _extractVariantColor(matchedVariant) ??
          selectedColor ??
          (rawColors.isNotEmpty
              ? _resolveSelectedColorPayload(
                  rawColors: rawColors,
                  selectedIndex: 0,
                )
              : null);

      return _ResolvedProductSelection(
        size: resolvedSize,
        color: resolvedColor,
      );
    }

    final fallbackSize =
        normalizedSize ?? (sizeOptions.isNotEmpty ? sizeOptions.first : null);
    final fallbackColor =
        selectedColor ??
        (rawColors.isNotEmpty
            ? _resolveSelectedColorPayload(
                rawColors: rawColors,
                selectedIndex: 0,
              )
            : null);

    return _ResolvedProductSelection(size: fallbackSize, color: fallbackColor);
  }

  List<Map<String, dynamic>> _buildBuyNowItems({
    required String productId,
    required _ResolvedProductSelection selection,
  }) {
    final item = <String, dynamic>{'product': productId, 'quantity': 1};

    if (selection.size != null && selection.size!.trim().isNotEmpty) {
      item['size'] = selection.size!.trim();
    }

    if (selection.color != null) {
      item['color'] = selection.color;
    }

    return [item];
  }

  VoucherViewData _toVoucherViewData(dynamic voucherData) {
    final discountType =
        _normalizeString(voucherData?.discountType) ?? 'Discount';
    final discountValue = _normalizeString(voucherData?.discountValue) ?? '0';
    final minSpend = _normalizeString(voucherData?.minSpend) ?? '0';
    final expiryDate = voucherData?.expiryDate;
    final useAt = voucherData?.useAt;
    final expiryText = expiryDate == null
        ? 'No expiry date'
        : 'Expires on ${expiryDate.toLocal().toString().split(" ").first}';
    final status = _resolveVoucherStatus(voucherData);
    final localizedTitle = _normalizeString(voucherData?.displayTitle);
    final localizedDescription = _normalizeString(
      voucherData?.displayDescription,
    );
    final title =
        (localizedTitle != null && localizedTitle.isNotEmpty)
        ? localizedTitle
        : '$discountValue $discountType Off';
    final subtitle =
        (localizedDescription != null && localizedDescription.isNotEmpty)
        ? localizedDescription
        : 'Purchase $minSpend or more and save $discountValue';
    final usedAtDate = useAt is DateTime
        ? useAt
        : DateTime.tryParse(useAt?.toString() ?? '');

    return VoucherViewData(
      voucher: Voucher(
        title: title,
        subtitle: subtitle,
        code: _normalizeString(voucherData?.code) ?? '',
        expiryText: expiryText,
        status: status,
      ),
      isUsed: voucherData?.hasUsed == true || status == VoucherStatus.used,
      usedAtText: usedAtDate?.toLocal().toString().split(" ").first,
    );
  }

  VoucherStatus _resolveVoucherStatus(dynamic voucherData) {
    final status = _normalizeString(voucherData?.status)?.toLowerCase();
    final hasUsed = voucherData?.hasUsed == true;

    if (hasUsed || status == 'used') {
      return VoucherStatus.used;
    }

    if (status == 'expired') {
      return VoucherStatus.expired;
    }

    return VoucherStatus.active;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final routeArguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      controller.initialize(routeArguments);
    });

    return Scaffold(
      appBar: CustomAppBar(label: Strings.productDetailsTitle.tr),

      bottomNavigationBar: Obx(() {
        final hasAccessToken = _hasAccessToken();
        final isCurrentSelectionInStock = controller.isCurrentSelectionInStock;
        final canUseCartActions =
            !hasAccessToken || isCurrentSelectionInStock;

        return Padding(
          padding: EdgeInsets.all(20.w(context)),
          child: CartAndBuy(
            isAddToCartEnabled: canUseCartActions,
            isBuyNowEnabled: canUseCartActions,
            onTapAddToCart: () async {
              if (!_hasAccessToken()) {
                showLoginRequiredDialog();
                return;
              }

              if (!isCurrentSelectionInStock) {
                showAppToast(
                  message: Strings.selectedVariantNotAvailable.tr,
                  isError: true,
                );
                return;
              }

              final product = controller.productData?.product;
              final productId = product?.id;
              if (productId == null || productId.isEmpty) {
                return;
              }

              final selection = _ResolvedProductSelection(
                size: controller.currentSelectedSizePayload,
                color: controller.currentSelectedColorPayload,
              );

              final isAdded = await Get.find<CartController>().addToCart(
                productId: productId,
                size: selection.size,
                color: selection.color,
                quantity: 1,
              );
              if (isAdded && mounted) {
                setState(() => _showFloatingCartButton = true);
              }
            },
            onTapBuyNow: () async {
              if (!_hasAccessToken()) {
                showLoginRequiredDialog();
                return;
              }

              if (!isCurrentSelectionInStock) {
                showAppToast(
                  message: Strings.selectedVariantNotAvailable.tr,
                  isError: true,
                );
                return;
              }

              final product = controller.productData?.product;
              final productId = product?.id;
              if (productId == null || productId.isEmpty) {
                return;
              }

              final selection = _ResolvedProductSelection(
                size: controller.currentSelectedSizePayload,
                color: controller.currentSelectedColorPayload,
              );
              final orderSummaryController =
                  Get.find<OrderSummaryController>();

              final isSuccess =
                  await orderSummaryController.createOrderSummary(
                itemsOverride: _buildBuyNowItems(
                  productId: productId,
                  selection: selection,
                ),
                onSuccessNavigate: () {
                  Get.to(() => const CheckoutScreen());
                },
              );

              if (!isSuccess) {
                return;
              }
            },
          ),
        );
      }),

      floatingActionButton: _showFloatingCartButton
          ? FloatingActionButton(
              heroTag: 'product-details-cart-fab',
              backgroundColor: const Color(0xFFFF6A00),
              foregroundColor: Colors.white,
              onPressed: () {
                PageNavigationService.to(context, AppRoutes.cart);
              },
              child: const Icon(Icons.shopping_cart_outlined),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ProductDetailsShimmer();
        }

        final productData = controller.productData;
        final product = productData?.product;
        final vendor = productData?.vendor;
        final category = productData?.category;
        final similarProducts = productData?.similarProducts ?? const [];
        final vouchers = productData?.vouchers ?? const [];
        final reviews = productData?.reviews ?? const [];
        final hasPurchase = productData?.hasPurchase ?? false;
        final inventoryType = controller.inventoryType;
        final sizeOptions = controller.availableSizes;
        final colorPayloadOptions = controller.availableColors;
        final colorOptions = colorPayloadOptions
            .map((item) => _parseColor(item['code']))
            .whereType<Color>()
            .toList();
        final displayPrice = (product?.discountPrice ?? product?.price ?? 0)
            .toString();
        final displayRating = (product?.avgRating ?? 0).toString();
        final displayReviewCount = (product?.ratingCount ?? 0).toString();
        final productImage = product?.images.isNotEmpty == true
            ? product!.images.first
            : '';
        final displayStoreImage =
            vendor?.profileAvatar ?? product?.banner ?? productImage;
        final topImageUrl = _normalizeString(product?.banner) ??
            (product?.images.isNotEmpty == true
                ? _normalizeString(product!.images.first)
                : null);
        final previewImages = product == null
            ? const <String>[]
            : _buildPreviewImages(
                banner: product.banner,
                images: product.images,
              );
        final thumbnailImages = product?.images
                .map(_normalizeString)
                .whereType<String>()
                .where((image) => image.isNotEmpty)
                .toList(growable: false) ??
            const <String>[];

        return RefreshIndicator(
          onRefresh: () => controller.loadProductData(force: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= PRODUCT IMAGE =================
                if (topImageUrl == null)
                  SizedBox(
                    height: 200.h(context),
                    width: width,
                    child: Center(child: Text(Strings.noImageFound.tr)),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showImagePreview(
                            context: context,
                            images: previewImages.isNotEmpty
                                ? previewImages
                                : [topImageUrl],
                            initialIndex: _previewIndexForUrl(
                              previewImages: previewImages.isNotEmpty
                                  ? previewImages
                                  : [topImageUrl],
                              imageUrl: topImageUrl,
                            ),
                          );
                        },
                        child: AppCachedNetworkImage(
                          imageUrl: topImageUrl,
                          imageWidth: width,
                          imageHeight: 200.h(context),
                          imageFit: BoxFit.cover,
                          radius: 12.r(context),
                        ),
                      ),

                      SizedBox(height: 8.h(context)),

                      SizedBox(
                        height: 100.h(context),
                        width: width,
                        child: thumbnailImages.isEmpty
                            ? const SizedBox.shrink()
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: thumbnailImages.length,
                                itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      final currentPreviewImages =
                                          previewImages.isNotEmpty
                                          ? previewImages
                                          : [topImageUrl];
                                      _showImagePreview(
                                        context: context,
                                        images: currentPreviewImages,
                                        initialIndex: _previewIndexForUrl(
                                          previewImages: currentPreviewImages,
                                          imageUrl: thumbnailImages[index],
                                        ),
                                      );
                                    },
                                    child: AppCachedNetworkImage(
                                      imageUrl: thumbnailImages[index],
                                      imageHeight: 100.h(context),
                                      imageWidth: 100.w(context),
                                      imageFit: BoxFit.cover,
                                      radius: 12.r(context),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 10.w(context));
                                },
                              ),
                      ),
                    ],
                  ),

                SizedBox(height: 18.h(context)),

                // ================= PRODUCT INFO =================
                ProductInfo(
                  productTitle: product?.displayTitle ?? '',
                  price: displayPrice,
                  rating: displayRating,
                  review: displayReviewCount,
                  storeName: vendor?.name ?? product?.brand ?? '',
                  storeCategory:
                      category?.title ?? product?.collectionType ?? '',
                  storeImageUrl: displayStoreImage,
                  shopId: vendor?.id,
                  isInStock: controller.isCurrentSelectionInStock,
                ),

                SizedBox(height: 10.h(context)),

                if (inventoryType == 'size_color' &&
                    sizeOptions.isNotEmpty) ...[
                  Text(
                    Strings.selectSize.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff4A4A4A),
                    ),
                  ),

                  SizedBox(height: 8.h(context)),

                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: sizeOptions.map((size) {
                          final bool isSelected =
                              controller.currentSelectedSize == size;

                          return Padding(
                            padding: EdgeInsets.only(right: 12.w(context)),
                            child: GestureDetector(
                              onTap: () {
                                controller.onSizeSelected(size);
                              },
                              child: SizePlate(
                                size: size,
                                backgroundColor: isSelected
                                    ? LightThemeColors.primaryColor
                                    : Colors.white,
                                textColor: isSelected
                                    ? Colors.white
                                    : const Color(0xff5E5E5E),
                                borderColor: isSelected
                                    ? LightThemeColors.primaryColor
                                    : const Color(0xffE6EAF0),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h(context)),
                ] else ...[
                  Container(),
                  SizedBox(height: 10.h(context)),
                ],

                if (colorOptions.isNotEmpty) ...[
                  Text(
                    Strings.selectColor.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff4A4A4A),
                    ),
                  ),

                  SizedBox(height: 8.h(context)),

                  Obx(
                    () => Row(
                      children: List.generate(colorOptions.length, (index) {
                        final bool isSelected =
                            controller.selectedColorIndex.value == index;

                        return Padding(
                          padding: EdgeInsets.only(right: 14.w(context)),
                          child: GestureDetector(
                            onTap: () {
                              controller.onColorSelected(index);
                            },
                            child: ColorPlate(
                              color: colorOptions[index],
                              borderColor: isSelected
                                  ? LightThemeColors.primaryColor
                                  : Colors.transparent,
                              padding: isSelected ? 2.w(context) : 0,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: 16.h(context)),
                ] else ...[
                  Container(),
                  
                ],

                // ================= DESCRIPTION =================
                Text(
                  Strings.productDescription.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp(context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff4A4A4A),
                  ),
                ),

                SizedBox(height: 10.h(context)),
                SizedBox(
                  width: width,
                  child: Html(
                    data: (product?.displayDescription.isNotEmpty == true)
                        ? product!.displayDescription
                        : Strings.noDescriptionFound.tr,
                  ),
                ),

                // Text(
                //   product?.description ?? '',
                //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //     fontSize: 14.sp(context),
                //     height: 1.7,
                //     fontWeight: FontWeight.w400,
                //     color: const Color(0xff7B7B7B),
                //   ),
                //   textAlign: TextAlign.justify,
                // ),
                SizedBox(height: 8.h(context)),

                const Divider(color: Color(0xffEAEAEA)),

                SizedBox(height: 10.h(context)),

                // ================= POLICY =================
                ProductPolicySection(),

                SizedBox(height: 28.h(context)),

                // ================= COMPLETE YOUR LOOK =================
                Row(
                  children: [
                    Text(
                      Strings.completeYourLook.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter',
                        color: const Color(0xff4A4A4A),
                      ),
                    ),

                    const Spacer(),
                    LabelContainer(
                      icon: Assets.icons.ai.path,
                      name: Strings.aiSuggested.tr,
                      contentColor: const Color(0xff039855),
                      backgroundColor: const Color(0xff039855),
                    ),
                  ],
                ),

                SizedBox(height: 8.h(context)),

                SizedBox(
                  height: 266.h(context),
                  child: similarProducts.isEmpty
                      ? Center(child: Text(Strings.noSimilarProducts.tr))
                      : ListView.separated(
                          itemCount: similarProducts.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 14.w(context));
                          },
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final similarProduct = similarProducts[index];
                            final name = similarProduct.displayTitle;
                            final image = similarProduct.banner ?? '';
                            final price =
                                (similarProduct.discountPrice ??
                                        similarProduct.price ??
                                        0)
                                    .toString();
                            final rating = (similarProduct.avgRating ?? 0)
                                .toString();
                            final isWishlisted =
                                similarProduct.isWishlisted ?? false;

                            return ProductCard(
                              name: name,
                              image: image,
                              price: price,
                              rating: rating,
                              isWishlisted: isWishlisted,
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.productDetails,
                                  arguments: {'productId': similarProduct.id},
                                );
                              },
                              onTapFavourite: () async {
                                final productId = similarProduct.id;
                                if (productId == null || productId.isEmpty) {
                                  return;
                                }

                                final accessToken =
                                    MySharedPref.getAccessToken();
                                if (accessToken?.trim().isNotEmpty != true) {
                                  showLoginRequiredDialog();
                                  return;
                                }

                                final updatedValue =
                                    await Get.find<WishlistController>()
                                        .toggleProductWishlist(
                                          productId: productId,
                                          currentValue: isWishlisted,
                                        );

                                if (updatedValue != null) {
                                  controller.updateSimilarProductWishlistStatus(
                                    productId: productId,
                                    isWishlisted: updatedValue,
                                  );
                                }
                              },
                            );
                          },
                        ),
                ),

                SizedBox(height: 10.h(context)),

                // ================= VOUCHERS =================
                ViewAllList(
                  title: Strings.vouchers.tr,
                  onTap: () {
                    final productTitle =
                        _normalizeString(product?.displayTitle) ??
                        Strings.unnamedProduct.tr;
                    final voucherViewData = vouchers
                        .map((voucher) => _toVoucherViewData(voucher))
                        .toList();
                    PageNavigationService.to(
                      context,
                      AppRoutes.allVouchers,
                      arguments: {
                        'title': '$productTitle ${Strings.vouchers.tr}',
                        'vouchers': voucherViewData,
                      },
                    );
                  },
                ),

                SizedBox(height: 10.h(context)),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: vouchers.isEmpty
                        ? [
                            SizedBox(
                              width: 320.w(context),
                              child: Text(Strings.noVouchersAvailable.tr),
                            ),
                          ]
                        : List.generate(vouchers.length, (index) {
                            final voucherData = vouchers[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == vouchers.length - 1
                                    ? 0
                                    : 10.w(context),
                              ),
                              child: SizedBox(
                                width: 320.w(context),
                                child: Builder(
                                  builder: (context) {
                                    final voucherViewData = _toVoucherViewData(
                                      voucherData,
                                    );
                                    return VoucherCardDesign(
                                      isCompact: true,
                                      voucher: voucherViewData.voucher,
                                      isUsed: voucherViewData.isUsed,
                                      usedAtText: voucherViewData.usedAtText,
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                  ),
                ),

                SizedBox(height: 20.h(context)),

                // ================= USER FEEDBACK =================
                ViewAllList(
                  title: Strings.userFeedbacks.tr,
                  onTap: () {
                    final productId = product?.id?.trim() ?? '';
                    if (productId.isEmpty) {
                      showAppToast(
                        message: Strings.productIdNotFound.tr,
                        isError: true,
                      );
                      return;
                    }

                    PageNavigationService.to(
                      context,
                      AppRoutes.allProductReview,
                      arguments: {
                        'title': Strings.reviewTitle.tr,
                        'productId': productId,
                      },
                    );
                  },
                ),

                SizedBox(height: 10.h(context)),

                reviews.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(12.w(context)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12.h(context)),
                          border: Border.all(
                            color: const Color(0xFFE7E7E7),
                            width: 1.w(context),
                          ),
                        ),
                        child: Center(child: Text(Strings.noReviewsYet.tr)),
                      )
                    : UserFeedbackSection(
                        feedbacks: reviews.map((review) {
                          return UserFeedbackModel(
                            userName: review.user?.name ?? Strings.anonymous.tr,
                            date: review.createdAt ?? DateTime.now(),
                            rating: (review.rating ?? 0).toDouble(),
                            comment: review.review ?? '',
                            images: review.files,
                          );
                        }).toList(),
                      ),

                if (hasPurchase) ...[
                  SizedBox(height: 12.h(context)),
                  CustomButton(
                    text: Strings.addReview.tr,
                    onPressed: () {
                      if (!_hasAccessToken()) {
                        showLoginRequiredDialog();
                        return;
                      }

                      final productId = product?.id?.trim() ?? '';
                      if (productId.isEmpty) {
                        showAppToast(
                          message: Strings.productIdNotFound.tr,
                          isError: true,
                        );
                        return;
                      }

                      final reviewController =
                          Get.find<ProductReviewController>();
                      reviewController.initialize(reference: productId);
                      Get.bottomSheet(
                        const ProductReviewBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                ],

                SizedBox(height: 20.h(context)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ResolvedProductSelection {
  const _ResolvedProductSelection({this.size, this.color});

  final String? size;
  final Map<String, String>? color;
}
