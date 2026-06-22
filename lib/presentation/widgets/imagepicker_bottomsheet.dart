import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';

class ImagePickerBottomSheet extends ConsumerWidget {
  const ImagePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Theme.of(context).cardColor,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    //   ),
    //   // :white_check_mark: Reusable sheet widget ko yahan call karein
    //   builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.xl.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle Bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyText.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                AppSpacing.vlg,

                // Take Photo Option (Camera)
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primaryYellow,
                    size: 24.sp,
                  ),
                  title: Text(
                    'Take Photo',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop(); // Close bottom sheet
                    await ref
                        .read(imagePickerProvider.notifier)
                        .captureWithCamera();
                  },
                ),

                // Choose from Gallery Option
                ListTile(
                  leading: Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.primaryYellow,
                    size: 24.sp,
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop(); // Close bottom sheet
                    await ref
                        .read(imagePickerProvider.notifier)
                        .pickFromGallery();
                  },
                ),

                // Remove Photo Option
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
                    Navigator.of(context).pop(); // Close bottom sheet
                    ref.read(imagePickerProvider.notifier).clear();
                  },
                ),
              ],
            ),
          ),
        );
      // },
   // );
  }
}