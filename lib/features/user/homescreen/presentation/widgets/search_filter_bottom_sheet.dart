import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/homescreen/data/models/search_filter_model.dart'
    as filter_model;
import 'package:hoodz/features/user/homescreen/presentation/controllers/search_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/filter_option_chip.dart';
import 'package:hoodz/urls.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({super.key});

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();
  late final Future<filter_model.SearchFilterModel?> _filterFuture;
  RangeValues? _priceRange;
  int? _priceMinBound;
  int? _priceMaxBound;

  @override
  void initState() {
    super.initState();
    _filterFuture = _fetchFilterPageData();
  }

  Future<filter_model.SearchFilterModel?> _fetchFilterPageData() async {
    final accessToken = MySharedPref.getAccessToken();
    final response = await _networkCaller.getRequest(
      Urls.searchFilterPageDataUrl,
      accessToken: accessToken,
    );

    if (!response.isSuccess) {
      return null;
    }

    return filter_model.SearchFilterModel.fromJson(response.responseData);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchScreenController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r(context))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.w(context),
            14.h(context),
            16.w(context),
            18.h(context),
          ),
          child: FutureBuilder<filter_model.SearchFilterModel?>(
            future: _filterFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data?.data;

              return SingleChildScrollView(
                child: Obx(() {
                  final filterCategories = controller.selectedFilterCategories;
                  final brand = controller.selectedBrand.value;
                  final selectedColor = controller.selectedColor.value;
                  final selectedSizes = controller.selectedSizes;
                  final gender = controller.selectedGender.value;
                  final distance = controller.distanceRange.value;

                  final minPrice = data?.minPrice ?? 0;
                  final maxPrice = data?.maxPrice ?? 0;
                  final safeMaxPrice = maxPrice > minPrice ? maxPrice : minPrice + 1;
                  final categories = data?.category ?? const [];
                  final brands = data?.brand ?? const [];
                  final colors = data?.color ?? const [];
                  final sizes = data?.size ?? const [];
                  final genders = data?.gender ?? const [];

                  if (_priceRange == null ||
                      _priceMinBound != minPrice ||
                      _priceMaxBound != safeMaxPrice) {
                    _priceMinBound = minPrice;
                    _priceMaxBound = safeMaxPrice;
                    _priceRange = RangeValues(
                      minPrice.toDouble(),
                      safeMaxPrice.toDouble(),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48.w(context),
                        height: 4.h(context),
                        margin: EdgeInsets.only(bottom: 16.h(context)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E7E7),
                          borderRadius: BorderRadius.circular(999.r(context)),
                        ),
                      ),
                      Text(
                        'Filter Result',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF393939),
                        ),
                      ),
                      SizedBox(height: 16.h(context)),
                      _SectionLabel(text: 'Category'),
                      SizedBox(height: 10.h(context)),
                      Wrap(
                        spacing: 8.w(context),
                        runSpacing: 10.h(context),
                        children: categories
                            .map(
                              (item) => FilterOptionChip(
                                label: item.title ?? '',
                                isSelected: filterCategories.contains(
                                  item.title ?? '',
                                ),
                                onTap: () => controller.selectFilterCategory(
                                  item.title ?? '',
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 16.h(context)),
                      _SectionLabel(text: 'Brand'),
                      SizedBox(height: 10.h(context)),
                      Wrap(
                        spacing: 8.w(context),
                        runSpacing: 10.h(context),
                        children: brands
                            .map(
                              (item) => FilterOptionChip(
                                label: item,
                                isSelected: brand == item,
                                onTap: () => controller.selectBrand(item),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 16.h(context)),
                      _SectionLabel(text: 'Color'),
                      SizedBox(height: 10.h(context)),
                      Wrap(
                        spacing: 8.w(context),
                        runSpacing: 10.h(context),
                        children: colors
                            .map(
                              (item) => FilterOptionChip(
                                label: item.name ?? '',
                                isSelected: selectedColor == item.name,
                                onTap: () => controller.selectColor(
                                  item.name ?? '',
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 16.h(context)),
                      _SectionLabel(text: 'Size'),
                      SizedBox(height: 10.h(context)),
                      Wrap(
                        spacing: 8.w(context),
                        runSpacing: 10.h(context),
                        children: sizes
                            .map(
                              (item) => FilterOptionChip(
                                label: item,
                                isSelected: selectedSizes.contains(item),
                                onTap: () => controller.selectSize(item),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 16.h(context)),
                      _SectionLabel(text: 'Gender'),
                      SizedBox(height: 10.h(context)),
                      Wrap(
                        spacing: 8.w(context),
                        runSpacing: 10.h(context),
                        children: genders
                            .map(
                              (item) => FilterOptionChip(
                                label: item,
                                isSelected: gender == item,
                                onTap: () => controller.selectGender(item),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 18.h(context)),
                      _SliderHeader(
                        label: 'Price Range:',
                        value:
                            '\$${_priceRange!.start.round()} - \$${_priceRange!.end.round()}',
                      ),
                      RangeSlider(
                        values: _priceRange!,
                        min: minPrice.toDouble(),
                        max: safeMaxPrice.toDouble(),
                        activeColor: const Color(0xFFFF6B00),
                        inactiveColor: const Color(0xFFEAEAEA),
                        onChanged: (values) {
                          setState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                      SizedBox(height: 6.h(context)),
                      _SliderHeader(
                        label: 'Max Distance:',
                        value: '${distance.end.round()} km',
                      ),
                      RangeSlider(
                        values: distance,
                        min: 0,
                        max: 20,
                        activeColor: const Color(0xFFFF6B00),
                        inactiveColor: const Color(0xFFEAEAEA),
                        onChanged: controller.updateDistanceRange,
                      ),
                      SizedBox(height: 14.h(context)),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Clear all',
                              backgroundColor: const Color(0xFFFFEADF),
                              textStyle: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 16.sp(context),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFF7A1A),
                                  ),
                              onPressed: controller.clearFilters,
                            ),
                          ),
                          SizedBox(width: 14.w(context)),
                          Expanded(
                            child: CustomButton(
                              text: 'Apply filter',
                              onPressed: () async {
                                await controller.fetchSearchProductsWithFilters(
                                  query: controller.searchTextController.text,
                                  minPrice: _priceRange?.start.round(),
                                  maxPrice: _priceRange?.end.round(),
                                  category: filterCategories.join(','),
                                  brand: brand,
                                  color: selectedColor,
                                  size: selectedSizes.join(','),
                                  gender: gender,
                                  maxDistance: distance.end.round(),
                                );

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 14.sp(context),
        fontWeight: FontWeight.w600,
        color: const Color(0xFF636363),
      ),
    );
  }
}

class _SliderHeader extends StatelessWidget {
  final String label;
  final String value;

  const _SliderHeader({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF666666),
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp(context),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
