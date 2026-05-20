import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class EditProfileFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isError;
  final String? errorText;
  final int? maxLength;
  final int? currentLength;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Widget? prefixIcon;

  const EditProfileFormField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.isError = false,
    this.errorText,
    this.maxLength,
    this.currentLength,
    this.keyboardType,
    this.maxLines = 1,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm.w),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.inputLabel.copyWith(
              fontSize: 11.sp,
              color: AppColors.greyText,
            ),
          ),
        ),

        AppSpacing.vsm,
         
          

        // Text Field
        Container(
          decoration: BoxDecoration(

           // color:Colors.red,
            //isDark ? AppColors.cardDark : AppColors.cardLight,
            // color: isError 
            //     ? Colors.red.withOpacity(0.1)
            //     : (isDark ? AppColors.cardDark : AppColors.cardLight),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isError
                  ? Colors.red : AppColors.borderDark,
                  //: (isDark ? AppColors.borderDark : AppColors.border),
              width: 1.w,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            style: AppTextStyles.inputText.copyWith(
              fontSize: 14.sp,

            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.inputHint.copyWith(
                fontSize: 14.sp,
                color: AppColors.greyText,
              ),
              prefixIcon: prefixIcon,
              prefixIconColor: AppColors.greyText,
              counterText: '', // Hide default counter
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: maxLines! > 1 ? 12.h : 14.h,
              ),
            ),
          ),
        ),

        // Character Counter
        if (maxLength != null && currentLength != null) ...[
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.xs.h,
                right: AppSpacing.sm.w,
              ),
              child: Text(
                '$currentLength / $maxLength',
                style: AppTextStyles.bodyRegular.copyWith(
                  fontSize: 11.sp,
                  color: AppColors.greyText,
                ),
              ),
            ),
          ),
        ],

        // Error Text
        if (errorText != null) ...[
          AppSpacing.vxs,
          Padding(
            padding: EdgeInsets.only(left: AppSpacing.sm.w),
            child: Text(
              errorText!,
              style: AppTextStyles.bodyRegular.copyWith(
                fontSize: 11.sp,
                color: Colors.red,
              ),
            ),
          ),
        ],

        AppSpacing.vlg,
      ],
    );
  }
}