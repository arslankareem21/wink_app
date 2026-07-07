import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';

class OtherUserProfileBio extends StatelessWidget {
  
  final String category;
  final String description;
  final String location;
  final String collaborationEmail;
  final String website;

  const OtherUserProfileBio({
    super.key,
    
    required this.category,
    required this.description,
    required this.location,
    required this.collaborationEmail,
    required this.website,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.isNotEmpty)...[
          AppSpacing.vxxl,
          Text(
            category,
            style: AppTextStyles.bodyRegular.copyWith(color: Colors.grey),
          ),
        ],
        if (description.isNotEmpty)...[
          AppSpacing.vxs,
          Text(description, style: AppTextStyles.bodyRegular),
        ],
        if (location.isNotEmpty)...[
          AppSpacing.vxs,
          Row(
            children: [
              Icon(Icons.location_on, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  location,
                  style: AppTextStyles.bodyRegular,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (website.isNotEmpty)...[
          AppSpacing.vxs,
          Row(
            children: [
              Icon(Icons.link, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  website,
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (collaborationEmail.isNotEmpty)...[
          AppSpacing.vxs,
          Row(
            children: [
              Icon(Icons.email, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  collaborationEmail,
                  style: AppTextStyles.bodyRegular,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}