import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText; // ADDED: nullable, won't break existing code

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.width,
    this.height,
    this.contentPadding,
    this.errorText, // ADDED
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText || widget.isPassword;
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword && widget.suffixIcon!= null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.suffixIcon!,
          IconButton(
            icon: Icon(
              _obscureText
                 ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.appBarDark,
              size: 20.sp,
            ),
            onPressed: () => setState(() => _obscureText =!_obscureText),
          ),
        ],
      );
    }

    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText
             ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.primaryYellow,
          size: 20.sp,
        ),
        onPressed: () => setState(() => _obscureText =!_obscureText),
      );
    }

    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.isPassword
         ? TextInputType.visiblePassword
          : widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.isPassword? 1 : widget.maxLines,
      minLines: widget.minLines,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      style: AppTextStyles.bodyRegular.copyWith(
        fontSize: 14.sp,
        color: AppColors.textFieldTextLight,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorText: widget.errorText, // ADDED
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffixIcon(),
        contentPadding: widget.contentPadding??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        hintStyle: AppTextStyles.bodyRegular.copyWith(
          fontSize: 14.sp,
          color: AppColors.subtitleLight,
        ),
        labelStyle: AppTextStyles.bodyRegular.copyWith(
          fontSize: 14.sp,
          color: AppColors.subtitleLight,
        ),
        errorStyle: AppTextStyles.bodyRegular.copyWith(
          fontSize: 12.sp,
          color: Colors.red,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );

    if (widget.width!= null || widget.height!= null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: textField,
      );
    }
    return textField;
  }
}