import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/shimmer/homescreen_shimmer.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_brand_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/brand_card_list.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/category_list.dart';
import 'package:hoodz/features/user/product/presentation/widgets/all_product_header.dart';

class AllBrandScreen extends GetView<AllBrandController> {
  const AllBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Obx(() {
        final categories = controller.brandCategories;
        final shops = controller.brandShops;
        final isCategoriesLoading = controller.isBrandTypesLoading.value;
        final isShopsLoading = controller.isCategoryShopsLoading.value;
        final selectedCategoryId = controller.selectedCategoryId.value;
        final selectedCategoryTitle = controller.selectedCategoryTitle.value;

        return Column(
          children: [
            AllProductHeader(
              isFilter: false,
              title: controller.pageTitle,
              onTapBack: () => Navigator.pop(context),
              onTapFilter: () {},
            ),
            SizedBox(height: 20.h(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 14.w(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.allCategories.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3A3A3A),
                      ),
                    ),
                    SizedBox(height: 14.h(context)),
                    SizedBox(
                      height: 120.h(context),
                      child: isCategoriesLoading && categories.isEmpty
                          ? const HomeCategoryShimmer()
                          : categories.isEmpty
                          ? Center(child: Text(Strings.noCategoryFound.tr))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10.w(context)),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final isSelected =
                                    selectedCategoryId == category.id;

                                return CategoriesList(
                                  image: category.displayImage.isEmpty
                                      ? AppStrings.demoImageUrl
                                      : category.displayImage,
                                  name: category.displayTitle,
                                  isSelected: isSelected,
                                  onTap: () {
                                    controller.selectCategory(category);
                                  },
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 10.h(context)),
                    Text(
                      selectedCategoryTitle.isEmpty
                          ? Strings.brands.tr
                          : '$selectedCategoryTitle ${Strings.shops.tr}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3A3A3A),
                      ),
                    ),
                    SizedBox(height: 14.h(context)),
                    if (selectedCategoryId.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 18.h(context),
                          horizontal: 12.w(context),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r(context)),
                          border: Border.all(color: const Color(0xFFEFEFEF)),
                        ),
                        child: Text(Strings.selectACategoryToViewShops.tr),
                      )
                    else if (isShopsLoading && shops.isEmpty)
                      const HomeBrandListShimmer()
                    else if (shops.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 18.h(context),
                          horizontal: 12.w(context),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r(context)),
                          border: Border.all(color: const Color(0xFFEFEFEF)),
                        ),
                        child: Text(Strings.noShopFound.tr),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shops.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h(context)),
                        itemBuilder: (context, index) {
                          final shop = shops[index];
                          return BrandCardList(
                            image: shop.displayImage.isEmpty
                                ? AppStrings.demoImageUrl
                                : shop.displayImage,
                            name: shop.displayTitle,
                            rating: shop.avgRating?.toStringAsFixed(1) ?? '0.0',
                            distance: shop.distance == null
                                ? ''
                                : '${shop.distance!.toStringAsFixed(1)} km',
                            time: shop.eta == null ? '' : '${shop.eta} min',
                            onTap: () {
                              if ((shop.id ?? '').isNotEmpty) {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.shop,
                                  arguments: {'shopId': shop.id},
                                );
                              }
                            },
                          );
                        },
                      ),
                    SizedBox(height: 20.h(context)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
