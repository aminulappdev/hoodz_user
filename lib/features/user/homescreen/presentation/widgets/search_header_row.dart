import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/circle_icon.dart';

class SearchHeaderRow extends StatelessWidget {
  const SearchHeaderRow({
    super.key,
    required this.leadingIconPath,
    required this.trailingIconPath,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onTapLeading,
    this.onTapTrailing,
    this.onTapSearch,
    this.onClear,
  });

  final String leadingIconPath;
  final String trailingIconPath;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapLeading;
  final VoidCallback? onTapTrailing;
  final VoidCallback? onTapSearch;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller ?? TextEditingController(),
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;
        final fieldHeight = 48.h(context);
        final borderRadius = 12.r(context);

        return Row(
          children: [
            CircleIcon(
              iconPath: leadingIconPath,
              size: 20,
              iconSize: 14,
              onTap: onTapLeading,
            ),
            SizedBox(width: 10.w(context)),
            Expanded(
              child: Container(
                height: fieldHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: const Color(0xFFFF7A1A),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onChanged: onChanged,
                        onSubmitted: onTapSearch != null
                            ? (_) => onTapSearch!()
                            : null,
                        textInputAction: TextInputAction.search,
                        textAlignVertical: TextAlignVertical.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp(context),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF303030),
                          height: 1.2,
                        ),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFA7A7A7),
                                height: 1.2,
                              ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w(context),
                          ),
                        ),
                      ),
                    ),
                    if (hasText)
                      GestureDetector(
                        onTap: onClear,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 4.w(context),
                            end: 8.w(context),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFFB8B8B8),
                            size: 18,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: onTapSearch,
                      child: Container(
                        height: fieldHeight,
                        constraints: BoxConstraints(minWidth: 72.w(context)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w(context),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A1A),
                          borderRadius: BorderRadiusDirectional.horizontal(
                            end: Radius.circular(borderRadius - 1.2),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          Strings.search.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 13.sp(context),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w(context)),
            CircleIcon(
              iconPath: trailingIconPath,
              size: 20,
              iconSize: 18,
              onTap: onTapTrailing,
            ),
          ],
        );
      },
    );
  }
}
