import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/about_row_info.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_tag.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
    required this.shopName,
    required this.description,
    required this.establishedYear,
    required this.location,
    required this.ratingSummary,
    required this.followers,
    required this.categories,
    required this.storePolicies,
  });

  final String shopName;
  final String description;
  final String establishedYear;
  final String location;
  final String ratingSummary;
  final String followers;
  final List<String> categories;
  final List<String> storePolicies;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shopName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18.sp(context),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff3A3A3A),
                ),
              ),
              SizedBox(height: 8.h(context)),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  height: 1.55,
                  color: const Color(0xff777777),
                ),
              ),
              SizedBox(height: 20.h(context)),
              AboutInfoRow(label: 'Established', value: establishedYear),
              AboutInfoRow(label: 'Location', value: location),
              AboutInfoRow(label: 'Rating', value: ratingSummary),
              AboutInfoRow(label: 'Followers', value: followers),
              SizedBox(height: 20.h(context)),
              Text(
                'Category',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp(context),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff4A4A4A),
                ),
              ),
              SizedBox(height: 12.h(context)),
              Wrap(
                spacing: 10.w(context),
                runSpacing: 10.h(context),
                children: categories
                    .map((category) => ShopTag(category: category))
                    .toList(),
              ),
              SizedBox(height: 24.h(context)),
              Text(
                'Store policies',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp(context),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff4A4A4A),
                ),
              ),
              SizedBox(height: 10.h(context)),
              ...storePolicies.map(
                (policy) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h(context)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 6.h(context),
                          right: 8.w(context),
                        ),
                        child: Container(
                          height: 4.h(context),
                          width: 4.w(context),
                          decoration: const BoxDecoration(
                            color: Color(0xff7A7A7A),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          policy,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                color: const Color(0xff666666),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
