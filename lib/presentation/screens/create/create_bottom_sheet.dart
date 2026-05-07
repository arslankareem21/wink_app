import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/presentation/widgets/create_tile.dart';

import '../../../../core/config/theme/app_colors.dart';


class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: AppColors.greyDark,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
      
            SizedBox(height: 28.h),
      
            CreateTile(
              icon: Icons.video_collection_rounded,
              title: 'Create Short',
              subtitle: 'Upload or record short videos',
              onTap: () {},
            ),
      
            SizedBox(height: 16.h),
      
            CreateTile(
              icon: Icons.image_rounded,
              title: 'Upload Post',
              subtitle: 'Share image with caption',
              onTap: () {},
            ),
      
            SizedBox(height: 16.h),
      
            CreateTile(
              icon: Icons.auto_stories_rounded,
              title: 'Add Story',
              subtitle: 'Post story for 24 hours',
              onTap: () {},
            ),
      
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}