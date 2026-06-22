import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';

class SuccessfullyPost extends ConsumerWidget {
  const SuccessfullyPost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSpacing.vxl,
                   AppSpacing.vxl,
                    AppSpacing.vxl,
                    AppSpacing.vxl,
                    AppSpacing.vxl,
                    AppSpacing.vxl,
                    AppSpacing.vxl,


                    AppSpacing.vxxl,

                    Text(
                      "Successfully Post",
                      style: AppTextStyles.authHeadline,
                      textAlign: TextAlign.center,
                    ),
                    
                    AppSpacing.vsm,
                    
                    Text(
                      "Your short video is now live and being shared with your community. Ready for next one?",
                      style: AppTextStyles.authSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    
                    AppSpacing.vlg,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(text: '0 views', width: 120.w, height: 45.h),
                        SizedBox(width: 10.w), 
                        AppButton(text: 'Share now', width: 120.w, height: 45.h),
                      ],
                    ),

                    const Spacer(), 

                    AppSpacing.vlg,

                    // Bottom Action Buttons
                    AppButton(
                      width: 240.w,
                      text: 'Back To Feed ->',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    
                    AppSpacing.vlg,
                    
                    AppButton(
                      width: 240.w,
                      text: 'View Analytics',
                      isGhost: true,
                      onPressed: () {},
                    ),
                    
                    AppSpacing.vxxl,
                  ],
                ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }


  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.xl.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.greyText.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              AppSpacing.vlg,

              // Take Photo Option
              ListTile(
                leading: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primaryYellow,
                  size: 24.sp,
                ),
                title: Text(
                  'Take Photo',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement camera
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primaryYellow,
                  size: 24.sp,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement gallery picker
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 24.sp,
                ),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String? {
  Null get user => null;
}


