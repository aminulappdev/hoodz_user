import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ShopCategoryTabBar extends StatelessWidget {
  const ShopCategoryTabBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onTapAll,
    required this.onTapCategory,
  });

  final List<String> categories;
  final String selectedCategory;
  final VoidCallback onTapAll;
  final ValueChanged<String> onTapCategory;

  @override
  Widget build(BuildContext context) {
    final isAllSelected = selectedCategory.trim().isEmpty;

    return SizedBox(
      height: 56.h(context),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => SizedBox(width: 24.w(context)),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _CategoryTab(
                    label: 'All',
                    isSelected: isAllSelected,
                    onTap: onTapAll,
                  );
                }

                final category = categories[index - 1];
                final isSelected = selectedCategory == category;

                return _CategoryTab(
                  label: category,
                  isSelected: isSelected,
                  onTap: () => onTapCategory(category),
                );
              },
            ),
          ),
          Container(height: 1, color: const Color(0xFFB7B7B7)),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? const Color(0xFFFF6A00)
        : const Color(0xFF7A7A7A);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15.sp(context),
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          SizedBox(height: 10.h(context)),
          Container(
            height: 2,
            width: 36.w(context),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFF6A00) : Colors.transparent,
              borderRadius: BorderRadius.circular(999.r(context)),
            ),
          ),
        ],
      ),
    );
  }
}
