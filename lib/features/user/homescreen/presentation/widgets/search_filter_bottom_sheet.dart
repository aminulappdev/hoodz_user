import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/search_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/filter_option_chip.dart';

class SearchFilterBottomSheet extends GetView<SearchScreenController> {
  const SearchFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            child: Obx(() {
              final filterCategory = controller.selectedFilterCategory.value;
              final brand = controller.selectedBrand.value;
              final color = controller.selectedColor.value;
              final size = controller.selectedSize.value;
              final gender = controller.selectedGender.value;
              final delivery = controller.deliveryRange.value;
              final distance = controller.distanceRange.value;

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
                  Row(
                    children: [
                      Expanded(
                        child: _PriceField(
                          label: 'Maximum price',
                          value: '\$00',
                        ),
                      ),
                      SizedBox(width: 12.w(context)),
                      Expanded(
                        child: _PriceField(
                          label: 'Minimum price',
                          value: '\$10000',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h(context)),
                  _SectionLabel(text: 'Category'),
                  SizedBox(height: 10.h(context)),
                  Wrap(
                    spacing: 8.w(context),
                    runSpacing: 10.h(context),
                    children: controller.filterCategories
                        .map(
                          (item) => FilterOptionChip(
                            label: item,
                            isSelected: filterCategory == item,
                            onTap: () => controller.selectFilterCategory(item),
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
                    children: controller.brands
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
                    children: controller.colors
                        .map(
                          (item) => FilterOptionChip(
                            label: item,
                            isSelected: color == item,
                            onTap: () => controller.selectColor(item),
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
                    children: controller.sizes
                        .map(
                          (item) => FilterOptionChip(
                            label: item,
                            isSelected: size == item,
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
                    children: controller.genders
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
                    label: 'Max Delivery Time:',
                    value: '${delivery.end.round()} min',
                  ),
                  RangeSlider(
                    values: delivery,
                    min: 0,
                    max: 60,
                    activeColor: const Color(0xFFFF6B00),
                    inactiveColor: const Color(0xFFEAEAEA),
                    onChanged: controller.updateDeliveryRange,
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
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  final String label;
  final String value;

  const _PriceField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8C8C8C),
          ),
        ),
        SizedBox(height: 8.h(context)),
        Container(
          height: 42.h(context),
          padding: EdgeInsets.symmetric(horizontal: 14.w(context)),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r(context)),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w500,
              color: const Color(0xFFC0C0C0),
            ),
          ),
        ),
      ],
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
