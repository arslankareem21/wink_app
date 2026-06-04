import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
<<<<<<< HEAD
=======
import 'package:wink_app/core/config/theme/app_spacing.dart';
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
import 'package:wink_app/core/config/theme/app_text_style.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
<<<<<<< HEAD
  final String? labelText;
=======
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
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
<<<<<<< HEAD
=======
    final int? maxLength;

>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
<<<<<<< HEAD
    this.labelText,
=======
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
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
<<<<<<< HEAD
    this.contentPadding,
=======
    this.contentPadding, 
    this.maxLength,
    // required String label,
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
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
    // Case 1: Both password toggle + custom suffixIcon
    if (widget.isPassword && widget.suffixIcon != null) {
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
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ],
      );
    }
    
    // Case 2: Only password toggle
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText 
              ? Icons.visibility_off_outlined 
              : Icons.visibility_outlined,
          color: AppColors.primaryYellow,
          size: 20.sp,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }
    
    // Case 3: Only custom suffixIcon
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
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
<<<<<<< HEAD
=======
     // maxLength: maxLength ,
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
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
<<<<<<< HEAD
        labelText: widget.labelText,
=======
        // labelText: widget.labelText,
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffixIcon(), // Fixed here
        contentPadding: widget.contentPadding ?? 
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        hintStyle: AppTextStyles.bodyRegular.copyWith(
          fontSize: 14.sp,
          color: AppColors.subtitleLight,
        ),
        labelStyle: AppTextStyles.bodyRegular.copyWith(
          fontSize: 14.sp,
          color: AppColors.subtitleLight,
        ),
      ),
    );

<<<<<<< HEAD
=======
    // if (maxLength != null && currentLength != null) ...[
    //       Align(
    //         alignment: Alignment.centerRight,
    //         child: Padding(
    //           padding: EdgeInsets.only(
    //             top: AppSpacing.xs.h,
    //             right: AppSpacing.sm.w,
    //           ),
    //           child: Text(
    //             '$currentLength / $maxLength',
    //             style: AppTextStyles.bodyRegular.copyWith(
    //               fontSize: 11.sp,
    //               color: AppColors.greyText,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],




    

        // Error Text
        // if (errorText != null) ...[
        //   AppSpacing.vxs,
        //   Padding(
        //     padding: EdgeInsets.only(left: AppSpacing.sm.w),
        //     child: Text(
        //       errorText!,
        //       style: AppTextStyles.bodyRegular.copyWith(
        //         fontSize: 11.sp,
        //         color: Colors.red,
        //       ),
        //     ),
        //   ),
        // ],



>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: textField,
      );
    }
    return textField;
  }
}