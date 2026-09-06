import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/shimmer/homescreen_shimmer.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/campaign_controller.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final CampaignController _controller = Get.find<CampaignController>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    _initialized = true;
    final arguments = ModalRoute.of(context)?.settings.arguments;
    _controller.initialize(
      arguments is Map ? Map<String, dynamic>.from(arguments) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        label: _controller.title.value.isEmpty
            ? 'Campaign'
            : _controller.title.value,
      ),
      body: Obx(() {
        if (_controller.isLoading.value &&
            _controller.campaignModel == null) {
          return const HomeCampaignShimmer();
        }

        return RefreshIndicator(
          onRefresh: _controller.fetchCampaign,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              20.w(context),
              16.h(context),
              20.w(context),
              24.h(context),
            ),
            children: [
              if (_controller.banner.value.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r(context)),
                  child: AppCachedNetworkImage(
                    imageUrl: _controller.banner.value,
                    imageHeight: 180.h(context),
                    imageFit: BoxFit.cover,
                    radius: 14.r(context),
                  ),
                ),
              if (_controller.title.value.isNotEmpty) ...[
                SizedBox(height: 18.h(context)),
                Text(
                  _controller.title.value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              SizedBox(height: 12.h(context)),
              if (_controller.products.isEmpty)
                SizedBox(
                  height: 180.h(context),
                  child: Center(child: Text(Strings.noProductsFound.tr)),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _controller.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14.w(context),
                    mainAxisSpacing: 14.h(context),
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = _controller.products[index];
                    return ProductCard(
                      name: product.title ?? '',
                      image: product.banner ?? '',
                      price: (product.discountPrice ?? product.price ?? 0)
                          .toString(),
                      rating: (product.avgRating ?? 0).toString(),
                      productId: product.id,
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
            ],
          ),
        );
      }),
    );
  }
}
