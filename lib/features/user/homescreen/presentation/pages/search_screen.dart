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
import 'package:hoodz/gen/assets.gen.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                onTapLeading: () => Navigator.pop(context),
                onTapTrailing: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const SearchFilterBottomSheet(),
                  );
                },
                onTapSearch: () {},
              ),
              SizedBox(height: 22.h(context)),
              SizedBox(
                height: 38.h(context),
                child: Obx(() {
                  final selectedCategory = controller.selectedCategory.value;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10.w(context)),
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      final isSelected = selectedCategory == category;
                      return CategoryChip(
                        label: category,
                        isSelected: isSelected,
                        onTap: () => controller.selectCategory(category),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 28.h(context)),
              Text(
                'Featured vendors',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  itemCount: controller.featuredVendors.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w(context)),
                  itemBuilder: (context, index) {
                    final vendor = controller.featuredVendors[index];
                    return ShopCard(
                      image: vendor['image'] ?? '',
                      name: vendor['name'] ?? '',
                      rating: '4.5 (12)',
                      distance: '4.5 km',
                      time: '25 min',
                      onTap: () {
                        PageNavigationService.to(
                          context,
                          AppRoutes.shop,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
