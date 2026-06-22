// presentation/components/profile/profile_bio.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class OtherUserProfileBio extends StatelessWidget {
  final String category;
    final String website;

  final String description;
  final String location;
  final String collaborationEmail;
  final String name;

  const OtherUserProfileBio({
    super.key,
    required this.category,
    required this.description,
    required this.location,
    required this.collaborationEmail, required this.name, required this.website,
  });

  @override
  Widget build(BuildContext context) {
    return  
    
    
     Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            //name
           Text(
            name,
            style: AppTextStyles.bodyRegular.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
                    AppSpacing.vsm,

          // Category
          Text(
            category,
            style: AppTextStyles.bodyRegular.copyWith(
              fontSize: 13.sp,
            ),
          ),

          AppSpacing.vsm,

          // Description
          Row(
            children: [
              
                Icon(
                Icons.star,
                size: 14.sp,
                //color: AppColors.greyText,
              ),
              AppSpacing.hxs,

              Text(
                description,
                style: AppTextStyles.bodyRegular.copyWith(
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),

          AppSpacing.vsm,

          // Location
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14.sp,
                //color: AppColors.greyText,
              ),
              AppSpacing.hxs,
              Text(
                location,
                style: AppTextStyles.bodyRegular.copyWith(
                  fontSize: 13.sp,
                  //color: AppColors.greyText,
                ),
              ),
            ],
          ),

          AppSpacing.vsm,

          // Collaboration Email
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14.sp,
               // color: AppColors.greyText,
              ),
              AppSpacing.hxs,
              Text(
                collaborationEmail,
                style: AppTextStyles.bodyRegular.copyWith(
                  fontSize: 13.sp,
                 // color: AppColors.greyText,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          AppSpacing.vsm,

          Text(
            website,
            style: AppTextStyles.bodyRegular.copyWith(
              fontSize: 13.sp,
            ),
          ),

        ],
      ),
    );
  }
}