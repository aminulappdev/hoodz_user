import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_filter_bottom_sheet.dart';
import 'package:hoodz/features/user/product/presentation/widgets/all_product_header.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_controller.dart';

class AllProductScreen extends GetView<AllProductController> {
  const AllProductScreen({super.key}); 
  
  @override
  Widget build(BuildContext context) {
    final routeArguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    controller.initialize(routeArguments);

    return Scaffold(
      backgroundColor: Colors.white, 
      body: Obx(
        () => Column(
          children: [
            _AllProductScreenHeader(controller: controller),
            Expanded( 
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(
                  20.w(context),
                  12.h(context),
                  20.w(context),
                  20.h(context),
                ),
                itemCount: controller.products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w(context),
                  mainAxisSpacing: 14.h(context),
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return ProductCard(
                    name: product['name'] ?? '',
                    image: product['image'] ?? '',
                    price: product['price'] ?? '',
                    rating: product['rating'] ?? '',
                    onTap: () {
                      PageNavigationService.to(
                        context,
                        AppRoutes.productDetails,
                      );
                    },
                    onTapFavourite: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllProductScreenHeader extends StatelessWidget {
  const _AllProductScreenHeader({required this.controller});

  final AllProductController controller;

  @override
  Widget build(BuildContext context) {
    return AllProductHeader(
      title: controller.title.value,
      onTapBack: () => Navigator.pop(context),
      onTapFilter: () {
        controller.syncDraftWithApplied();
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AllProductFilterBottomSheet(),
        );
      },
    );
  }
}
