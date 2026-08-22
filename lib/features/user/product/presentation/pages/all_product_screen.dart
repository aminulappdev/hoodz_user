import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/ai_recommended_product_controller.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_filter_bottom_sheet.dart';
import 'package:hoodz/features/user/product/presentation/widgets/all_product_header.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_controller.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  Map<String, dynamic>? _routeArguments;
  dynamic _controller;
  bool _initialized = false;

  dynamic _resolveController(Map<String, dynamic>? arguments) {
    final source = arguments?['source'] as String? ?? 'trending';

    if (source == 'ai') {
      return Get.find<AiRecommendedProductController>();
    }
    return Get.find<AllTrendingProductController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _routeArguments ??=
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _controller ??= _resolveController(_routeArguments);

    if (!_initialized) {
      _initialized = true;
      _controller.initialize(_routeArguments);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _AllProductScreenHeader(controller: controller),
            Expanded(
              child: controller.products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : GridView.builder(
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
                          name: product.title ?? '',
                          image: product.banner ?? '',
                          price: (product.discountPrice ?? product.price ?? 0)
                              .toString(),
                          rating: (product.avgRating ?? 0).toString(),
                          onTap: () {
                            PageNavigationService.to(
                              context,
                              AppRoutes.productDetails,
                              arguments: {'productId': product.id},
                            );
                          },
                          onTapFavourite: () {},
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}

class _AllProductScreenHeader extends StatelessWidget {
  const _AllProductScreenHeader({required this.controller});

  final dynamic controller;

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
          builder: (_) => AllProductFilterBottomSheet(controller: controller),
        );
      },
    );
  }
}
