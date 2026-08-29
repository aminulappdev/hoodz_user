import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/search_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/banner_card.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/category_chip.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/search_filter_bottom_sheet.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/search_header_row.dart';
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
                    hintText: 'Search...',
                    controller: controller.searchTextController,
                    onChanged: controller.updateSearchQuery,
                    onTapLeading: () => Navigator.pop(context),
                    onTapTrailing: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const SearchFilterBottomSheet(),
                      );
                    },
                    onTapSearch: () {
                      final query = controller.searchTextController.text.trim();
                      if (query.isEmpty) {
                        controller.clearSearchText();
                        return;
                      }

                      controller.fetchSearchProducts(query: query);
                    },
                    onClear: controller.clearSearchText,
                  ),
                  SizedBox(height: 22.h(context)),
                  if (showProductResults) ...[
                    if (isProductLoading)
                      const LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor: Color(0xFFF1F1F1),
                        color: Color(0xFFFF7A1A),
                      )
                    else if (searchProducts.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 24.h(context)),
                        child: Text(
                          'No products found',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFA7A7A7),
                              ),
                        ),
                      )
                    else ...[
                      Text(
                        'Products',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 18.sp(context),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF363636),
                            ),
                      ),
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
                        itemBuilder: (context, index) {
                          final product = searchProducts[index];
                          final priceValue =
                              product.discountPrice ?? product.price ?? 0;
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
                            subtitle:
                                product.collectionType ?? product.brand ?? '',
                            oldPrice: oldPrice,
                            stockLabel: product.inStock == true
                                ? 'In stock'
                                : 'Out of stock',

                            onTapFavourite: () {},
                            onTap: () {
                              PageNavigationService.to(
                                context,
                                AppRoutes.productDetails,
                                arguments: {'productId': product.id},
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ] else if (searchQuery.isNotEmpty) ...[
                    if (isSuggestionLoading)
                      const LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor: Color(0xFFF1F1F1),
                        color: Color(0xFFFF7A1A),
                      )
                    else if (suggestions.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 24.h(context)),
                        child: Text(
                          'No suggestions found',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFA7A7A7),
                              ),
                        ),
                      )
                    else
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
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
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
                  ] else ...[
                    if (categories.isNotEmpty) ...[
                      SizedBox(
                        height: 38.h(context),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: 10.w(context)),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final label = category.title ?? '';
                            final isSelected =
                                controller.selectedCategory.value.trim() ==
                                label.trim();

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
                      ),
                    ],
                    if (isLoading) ...[
                      SizedBox(height: 12.h(context)),
                      const LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor: Color(0xFFF1F1F1),
                        color: Color(0xFFFF7A1A),
                      ),
                    ],
                    SizedBox(height: 24.h(context)),
                    _SectionHeader(
                      title: 'Search History',
                      actionText: 'Clear All',
                      actionIcon: Icons.delete_outline_rounded,
                      onActionTap: controller.clearSearchHistory,
                    ),
                    SizedBox(height: 12.h(context)),
                    if (histories.isEmpty)
                      Text(
                        'No recent searches',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp(context),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFA7A7A7),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 10.w(context),
                        runSpacing: 10.h(context),
                        children: histories
                            .map(
                              (history) => _SearchChip(
                                label: history.query ?? '',
                                onTap: () => controller.useHistoryQuery(
                                  history.query ?? '',
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    if (featuredVendors.isNotEmpty) ...[
                      SizedBox(height: 26.h(context)),
                      Text(
                        'Featured vendors',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 18.sp(context),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF363636),
                            ),
                      ),
                      SizedBox(height: 16.h(context)),
                      SizedBox(
                        height: 96.h(context),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredVendors.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: 12.w(context)),
                          itemBuilder: (context, index) {
                            final vendor = featuredVendors[index];
                            final ratingCount = vendor.ratingCount ?? 0;
                            final avgRating =
                                vendor.avgRating?.toStringAsFixed(1) ?? '0.0';
                            final distanceKm = vendor.distance?.distanceKm;
                            final durationMinutes =
                                vendor.distance?.durationMinutes;

                            return ShopCard(
                              image: vendor.profileAvatar ?? '',
                              name: vendor.name ?? '',
                              rating: '$avgRating ($ratingCount)',
                              distance: distanceKm == null
                                  ? 'N/A'
                                  : '${distanceKm.toStringAsFixed(1)} km',
                              time: durationMinutes == null
                                  ? 'N/A'
                                  : '$durationMinutes min',
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
                      ),
                    ],
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.actionIcon,
    required this.onActionTap,
  });

  final String title;
  final String actionText;
  final IconData actionIcon;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18.sp(context),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF363636),
            ),
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Row(
            children: [
              Text(
                actionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8C8C8C),
                ),
              ),
              SizedBox(width: 4.w(context)),
              Icon(actionIcon, size: 18, color: const Color(0xFF8C8C8C)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchChip extends StatelessWidget {
  const _SearchChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w(context),
          vertical: 8.h(context),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(999.r(context)),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6C6C6C),
          ),
        ),
      ),
    );
  }
}
