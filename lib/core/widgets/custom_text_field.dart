// lib/app/core/widgets/custom_text_filed.dart
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';

class CustomTextField extends StatefulWidget { 
  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.style = const TextStyle(color: Color(0xff8C8C8C)),
    this.textDirection,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.clipBehavior = Clip.hardEdge,
    this.fillColor = const Color(0xffFFFFFF),
    this.borderRadius = 30.0,
    this.validator,
    this.hintStyle,
    this.hintText,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 8,
    ),
    this.borderColor = LightThemeColors.textFieldBorderColor,
    this.focusedBorderColor = LightThemeColors.textFieldBorderColor,
    this.errorBorderColor = Colors.red,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconColor,
    this.items,
    this.value,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.suffixIconColor,
    this.suffixIconOnPressed,
    this.prefixIconOnPressed,
    this.dropdownFillColor,
    this.inputFormatters,
  });
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextDirection? textDirection;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final Clip clipBehavior;
  final Color fillColor;
  final double borderRadius;
  final FormFieldValidator<String>? validator;
  final TextStyle? hintStyle;
  final String? hintText;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final String? suffixIcon;
  final String? prefixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? dropdownFillColor;
  final VoidCallback? suffixIconOnPressed;
  final VoidCallback? prefixIconOnPressed;
  final List<TextInputFormatter>? inputFormatters;

  // Dropdown
  final List<DropdownMenuItem<String>>? items;
  final String? value;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late String? _selectedValue;

  TextStyle? get _dropdownTextStyle =>
      widget.hintStyle ??
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xff7A7A7A),
      );

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value ?? widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedValue = widget.value;
    }
  }

  InputDecoration _defaultDecoration() {
    return InputDecoration(
      suffixIcon: widget.suffixIcon != null
          ? GestureDetector(
              onTap: widget.suffixIconOnPressed,
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(child: CrashSafeImage(widget.suffixIcon)),
                ),
              ),
            )
          : null,
      suffixIconConstraints: widget.suffixIcon != null
          ? const BoxConstraints(minHeight: 12, minWidth: 12)
          : null,
      prefixIcon: widget.prefixIcon != null
          ? GestureDetector(
              onTap: widget.prefixIconOnPressed,
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(child: CrashSafeImage(widget.prefixIcon)),
                ),
              ),
            )
          : null,
      prefixIconConstraints: widget.prefixIcon != null
          ? const BoxConstraints(minHeight: 12, minWidth: 12)
          : null,
      prefixIconColor: widget.prefixIconColor ?? const Color(0xffACACAC),
      hintText: widget.hintText,
      hintStyle:
          widget.hintStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xffACACAC),
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
      filled: true,
      fillColor: widget.fillColor,
      contentPadding: widget.contentPadding,
      suffixIconColor: widget.suffixIconColor ?? const Color(0xffACACAC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: widget.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: widget.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: widget.focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dropdown Mode
    if (widget.items != null && widget.items!.isNotEmpty) {
      return DropdownButtonFormField<String>(
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        initialValue: _selectedValue,
        onTap: widget.onTap,
        hint: Text(widget.hintText ?? '', style: _dropdownTextStyle),
        style: _dropdownTextStyle,
        items: widget.items,
        validator: widget.validator,
        onChanged: widget.enabled
            ? (val) {
                setState(() => _selectedValue = val);
                widget.onChanged?.call(val ?? '');
              }
            : null,
        decoration: widget.decoration ?? _defaultDecoration(),
        dropdownColor: widget.dropdownFillColor,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xffACACAC),
          size: 20,
        ),
        iconSize: 20,
        menuMaxHeight: 240,
        // style: widget.style ?? const TextStyle(color: Color(0xffA2A2A2)),
      );
    }

    // Normal TextField
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      // style: widget.style ?? const TextStyle(color: Color(0xff8C8C8C)),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      expands: widget.expands,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      enabled: widget.enabled,
      validator: widget.validator,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      decoration: widget.decoration ?? _defaultDecoration(),
      clipBehavior: widget.clipBehavior,
    );
  }
}
