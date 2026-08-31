import 'package:flutter/material.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/banner_card.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/view_all.dart';

class ProductSection extends StatelessWidget {
  const ProductSection({
    super.key,
    required this.recommendedItems,
    required this.products,
  });

  final List<Map<String, String>> recommendedItems;
  final List<Map<String, String>> products;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.highRecommended.tr,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp(context),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.h(context)),

              SizedBox(
                height: 112.h(context),
                child: ListView.separated(
                  itemCount: recommendedItems.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 14.w(context)),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final product = recommendedItems[index];
                    return ShopCard(
                      image: product['image'] ?? '',
                      name: product['name'] ?? '',
                      rating: '4.5 (12)',
                      distance: '4.5 km',
                      time: '25 min',
                      onTap: () {
                        PageNavigationService.to(context, AppRoutes.shop);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h(context)),
              ViewAllList(
                title: Strings.allProducts.tr,
                onTap: () => PageNavigationService.to(
                  context,
                  AppRoutes.allProduct,
                  arguments: {'title': Strings.allProducts.tr},
                ),
              ),
              SizedBox(height: 8.h(context)),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w(context),
                  mainAxisSpacing: 14.h(context),
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    name: product['name'] ?? '',
                    image: product['image'] ?? '',
                    price: product['price'] ?? '',
                    rating: product['rating'] ?? '',
                    productId: product['id'],
                    onTap: () {
                      PageNavigationService.to(
                        context,
                        AppRoutes.productDetails,
                        arguments: {'productId': product['id']},
                      );
                    },
                    onTapFavourite: () {},
                  );
                },
              ),
              SizedBox(height: 12.h(context)),
            ],
          ),
        ),
      ),
    );
  }
}
