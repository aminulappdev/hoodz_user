import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_brand_controller.dart';
import 'package:hoodz/features/user/product/presentation/widgets/all_product_header.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/brand_card_list.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/category_list.dart';

class AllBrandScreen extends StatefulWidget {
  const AllBrandScreen({super.key});
 
  @override
  State<AllBrandScreen> createState() => _AllBrandScreenState();
}

class _AllBrandScreenState extends State<AllBrandScreen> {
  late final AllBrandController controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AllBrandController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;

    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    controller.initialize(arguments);

    _isInitialized = true;
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      body: Column(
        children: [
          Obx(
            () => AllProductHeader(
              isFilter: false,
              title: controller.title.value,
              onTapBack: () => Navigator.pop(context),
              onTapFilter: () {},
            ),
          ),

          SizedBox(height: 20.h(context)),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w(context)),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'All Categories',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp(context),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF3A3A3A),
                  ),
                ),

                SizedBox(height: 14.h(context)),

                SizedBox(
                  height: 120.h(context),

                  child: Obx(() {
                    final selectedBrand = controller.selectedBrand.value;

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,

                      itemCount: controller.categories.length,

                      separatorBuilder: (context, index) =>
                          SizedBox(width: 10.w(context)),

                      itemBuilder: (context, index) {
                        final brand = controller.categories[index];

                        return CategoriesList(
                          image: AppStrings.demoImageUrl,

                          name: brand,

                          isSelected: selectedBrand == brand,

                          onTap: () {
                            controller.toggleBrand(brand);
                          },
                        );
                      },
                    );
                  }),
                ),

                Text(
                  'Brands',

                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp(context),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF3A3A3A),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h(context)),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                14.w(context),
                0,
                14.w(context),
                20.h(context),
              ),

              separatorBuilder: (context, index) =>
                  SizedBox(height: 8.h(context)),

              itemCount: 50,

              itemBuilder: (context, index) {
                return BrandCardList(
                  onTap: () {
                    PageNavigationService.to(context, AppRoutes.shop);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
