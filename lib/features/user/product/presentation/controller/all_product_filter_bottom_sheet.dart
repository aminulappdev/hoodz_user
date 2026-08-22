import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/filter_option_chip.dart';

class AllProductFilterBottomSheet extends StatelessWidget {
  const AllProductFilterBottomSheet({super.key, required this.controller});

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r(context)),
        ),
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
            child: Obx(
              () => Column(
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
                        child: _PriceLabel(
                          label: 'Minimum',
                          value:
                              '\$${controller.draftPriceRange.value.start.round()}',
                        ),
                      ),
                      Expanded(
                        child: _PriceLabel(
                          label: 'Maximum',
                          alignment: CrossAxisAlignment.end,
                          value:
                              '\$${controller.draftPriceRange.value.end.round()}.00',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h(context)),
                  RangeSlider(
                    values: controller.draftPriceRange.value,
                    min: 0,
                    max: 110,
                    activeColor: const Color(0xFFFF6B00),
                    inactiveColor: const Color(0xFFEAEAEA),
                    onChanged: controller.updateDraftPriceRange,
                  ),
                  SizedBox(height: 12.h(context)),
                  _SectionLabel(text: 'Color'),
                  SizedBox(height: 10.h(context)),
                  Wrap(
                    spacing: 8.w(context),
                    runSpacing: 10.h(context),
                    children: controller.colors
                        .map<Widget>(
                          (item) => FilterOptionChip(
                            label: item,
                            isSelected: controller.draftColors.contains(item),
                            onTap: () => controller.selectDraftColor(item),
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
                        .map<Widget>(
                          (item) => FilterOptionChip(
                            label: item,
                            isSelected: controller.draftSizes.contains(item),
                            onTap: () => controller.selectDraftSize(item),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 20.h(context)),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Clear all',
                          backgroundColor: const Color(0xFFF3F3F3),
                          textStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 16.sp(context),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFF7A1A),
                              ),
                          onPressed: controller.clearDraftFilters,
                        ),
                      ),
                      SizedBox(width: 14.w(context)),
                      Expanded(
                        child: CustomButton(
                          text: 'Apply filter',
                          onPressed: () {
                            controller.applyFilters();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

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

class _PriceLabel extends StatelessWidget {
  const _PriceLabel({
    required this.label,
    required this.value,
    this.alignment = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp(context),
            color: const Color(0xFF7C7C7C),
          ),
        ),
        SizedBox(height: 4.h(context)),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp(context),
            color: const Color(0xFF9A9A9A),
          ),
        ),
      ],
    );
  }
}
