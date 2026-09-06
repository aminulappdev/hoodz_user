import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/shimmer/homescreen_shimmer.dart';
import 'package:hoodz/features/user/homescreen/data/models/initial_search_model.dart';
import 'package:hoodz/features/user/homescreen/data/models/product_search_model.dart'
    as product_search;
import 'package:hoodz/features/user/homescreen/data/models/search_product_model.dart'
    as search_product;
import 'package:hoodz/features/user/homescreen/presentation/controllers/search_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/banner_card.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/category_chip.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/search_filter_bottom_sheet.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/search_header_row.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/search_history_widgets.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/gen/assets.gen.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          final categories = controller.categories;
          final histories = controller.histories;
          final featuredVendors = controller.featuredVendors;
          final isLoading = controller.isLoading.value;
          final searchQuery = controller.searchQuery.value.trim();
          final suggestions = controller.suggestions;
          final isSuggestionLoading = controller.isSuggestionLoading.value;
          final isProductLoading = controller.isProductLoading.value;
          final showProductResults = controller.showProductResults.value;
          final searchProducts = controller.searchProducts;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                14.w(context),
                10.h(context),
                14.w(context),
                20.h(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18.h(context)),
                  SearchHeaderRow(
                    leadingIconPath: Assets.icons.arrow.path,
                    trailingIconPath: Assets.icons.filter02.path,
                    hintText: Strings.search.tr,
                    controller: controller.searchTextController,
                    onChanged: controller.updateSearchQuery,
                    onTapLeading: () => Navigator.pop(context),
                    onTapTrailing: () => _openFilterSheet(context),
                    onTapSearch: _handleSearchTap,
                    onClear: controller.clearSearchText,
                  ),
                  SizedBox(height: 22.h(context)),
                  if (showProductResults)
                    ..._buildProductResults(
                      context,
                      isProductLoading: isProductLoading,
                      searchProducts: searchProducts,
                    )
                  else if (searchQuery.isNotEmpty)
                    ..._buildSuggestions(
                      context,
                      isSuggestionLoading: isSuggestionLoading,
                      suggestions: suggestions,
                    )
                  else
                    ..._buildInitialContent(
                      context,
                      categories: categories,
                      histories: histories,
                      featuredVendors: featuredVendors,
                      isLoading: isLoading,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SearchFilterBottomSheet(),
    );
  }

  void _handleSearchTap() {
    final query = controller.searchTextController.text.trim();
    if (query.isEmpty) {
      controller.clearSearchText();
      return;
    }

    controller.fetchSearchProducts(query: query);
  }

  List<Widget> _buildProductResults(
    BuildContext context, {
    required bool isProductLoading,
    required List<search_product.Datum> searchProducts,
  }) {
    if (isProductLoading) {
      return [_buildLoadingIndicator()];
    }

    if (searchProducts.isEmpty) {
      return [_buildEmptyMessage(context, Strings.noProductsFound.tr)];
    }

    return [
      _buildSectionTitle(context, Strings.products.tr),
      SizedBox(height: 14.h(context)),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: searchProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h(context),
          crossAxisSpacing: 12.w(context),
          childAspectRatio: 0.68,
        ),
        itemBuilder: (context, index) =>
            _buildProductCard(context, searchProducts[index]),
      ),
    ];
  }

  Widget _buildProductCard(
    BuildContext context,
    search_product.Datum product,
  ) {
    final priceValue = product.discountPrice ?? product.price ?? 0;
    final oldPrice =
        product.discountPrice != null &&
            product.price != null &&
            product.price != product.discountPrice
        ? '\$${product.price}'
        : null;

    return ProductCard(
      name: product.title ?? '',
      image: product.banner ?? '',
      price: '\$$priceValue',
      rating:
          '${product.avgRating?.toStringAsFixed(1) ?? '0.0'} (${product.ratingCount ?? 0})',
      subtitle: product.collectionType ?? product.brand ?? '',
      oldPrice: oldPrice,
      stockLabel:
          product.inStock == true ? Strings.inStock.tr : Strings.outOfStock.tr,
      onTapFavourite: () {},
      onTap: () {
        PageNavigationService.to(
          context,
          AppRoutes.productDetails,
          arguments: {'productId': product.id},
        );
      },
    );
  }

  List<Widget> _buildSuggestions(
    BuildContext context, {
    required bool isSuggestionLoading,
    required List<product_search.Suggestion> suggestions,
  }) {
    if (isSuggestionLoading) {
      return [_buildLoadingIndicator()];
    }

    if (suggestions.isEmpty) {
      return [_buildEmptyMessage(context, Strings.noSuggestionsFound.tr)];
    }

    return [
      ListView.separated(
        itemCount: suggestions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFEDEDED)),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final text = suggestion.query ?? '';

          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 17.sp(context),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F1F1F),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_outward_rounded,
              color: Color(0xFFD5D5D5),
            ),
            onTap: () {
              controller.fillSearchText(text);
              controller.fetchSearchProducts(query: text);
            },
          );
        },
      ),
    ];
  }

  List<Widget> _buildInitialContent(
    BuildContext context, {
    required List<Category> categories,
    required List<History> histories,
    required List<FeaturedVendor> featuredVendors,
    required bool isLoading,
  }) {
    return [
      if (categories.isNotEmpty) _buildCategoryList(context, categories),
      if (isLoading) ...[
        SizedBox(height: 12.h(context)),
        _buildLoadingIndicator(),
      ],
      SizedBox(height: 24.h(context)),
      SearchSectionHeader(
        title: Strings.searchHistory.tr,
        actionText: Strings.clearAll.tr,
        actionIcon: Icons.delete_outline_rounded,
        onActionTap: controller.clearSearchHistory,
      ),
      SizedBox(height: 12.h(context)),
      if (histories.isEmpty)
        _buildEmptyMessage(context, Strings.noRecentSearches.tr)
      else
        Wrap(
          spacing: 10.w(context),
          runSpacing: 10.h(context),
          children: histories
              .map<Widget>(
                (history) => SearchChip(
                  label: history.query ?? '',
                  onTap: () => controller.useHistoryQuery(history.query ?? ''),
                ),
              )
              .toList(),
        ),
      if (featuredVendors.isNotEmpty) ...[
        SizedBox(height: 26.h(context)),
        _buildSectionTitle(context, Strings.featuredVendors.tr),
        SizedBox(height: 16.h(context)),
        _buildFeaturedVendorList(context, featuredVendors),
      ],
    ];
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categories) {
    return SizedBox(
      height: 38.h(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w(context)),
        itemBuilder: (context, index) {
          final category = categories[index];
          final label = category.title ?? '';
          final isSelected =
              controller.selectedCategory.value.trim() == label.trim();

          return CategoryChip(
            label: label,
            isSelected: isSelected,
            onTap: () {
              controller.selectCategory(label);
              controller.fillSearchText(label);
              controller.fetchSearchProducts(query: label);
            },
          );
        },
      ),
    );
  }

  Widget _buildFeaturedVendorList(
    BuildContext context,
    List<FeaturedVendor> featuredVendors,
  ) {
    return SizedBox(
      height: 96.h(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: featuredVendors.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w(context)),
        itemBuilder: (context, index) {
          final vendor = featuredVendors[index];
          final ratingCount = vendor.ratingCount ?? 0;
          final avgRating = vendor.avgRating?.toStringAsFixed(1) ?? '0.0';
          final distanceKm = vendor.distance?.distanceKm;
          final durationMinutes = vendor.distance?.durationMinutes;

          return ShopCard(
            image: vendor.profileAvatar ?? '',
            name: vendor.name ?? '',
            rating: '$avgRating ($ratingCount)',
            distance: distanceKm == null
                ? Strings.notAvailable.tr
                : '${distanceKm.toStringAsFixed(1)} ${Strings.kilometer.tr}',
            time: durationMinutes == null
                ? Strings.notAvailable.tr
                : '$durationMinutes ${Strings.minute.tr}',
            onTap: () {
              PageNavigationService.to(
                context,
                AppRoutes.shop,
                arguments: {'shopId': vendor.id},
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontSize: 18.sp(context),
        fontWeight: FontWeight.w700,
        color: const Color(0xFF363636),
      ),
    );
  }

  Widget _buildEmptyMessage(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h(context)),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp(context),
          fontWeight: FontWeight.w500,
          color: const Color(0xFFA7A7A7),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const HomeShimmerBox(
      height: 8,
      width: double.infinity,
      radius: 4,
    );
  }
}
