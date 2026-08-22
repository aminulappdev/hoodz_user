import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';

class CarouselBanner extends StatefulWidget {
  final List<dynamic> bannerList;
  final Function(String reference) onTap;
  const CarouselBanner(this.bannerList, this.onTap, {super.key});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  int currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          itemCount: widget.bannerList.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                widget.onTap(widget.bannerList[index].reference);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r(context)),
                ),
                child: AppCachedNetworkImage(
                  imageUrl: widget.bannerList[index].banner,
                  imageHeight: 170.h(context),
                  imageFit: BoxFit.cover,
                  radius: 12.r(context),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 170.h(context),
            viewportFraction: 1,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              if (mounted) {
                setState(() => currentBannerIndex = index);
              }
            },
          ),
        ),
        SizedBox(height: 12.h(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.bannerList.length, (index) {
            final isActive = currentBannerIndex == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 3.w(context)),
              height: 6.h(context),
              width: isActive ? 22.w(context) : 6.w(context),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFFF5C00)
                    : const Color(0xFFFFD0B2),
                borderRadius: BorderRadius.circular(999.r(context)),
              ),
            );
          }),
        ),
      ],
    );
  }
}
