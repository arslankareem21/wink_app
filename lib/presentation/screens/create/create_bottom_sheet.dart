import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/presentation/screens/create/decision-screen.dart';
import 'package:wink_app/presentation/screens/create/edit-video_screen.dart';

import 'package:wink_app/presentation/screens/create/edit_preview_screen.dart';
import 'package:wink_app/presentation/widgets/create_tile.dart';

class CreateBottomSheet extends ConsumerWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ImagePicker picker = ImagePicker();

    Future<void> handlePickVideo() async {
      final XFile? file = await picker.pickVideo(source: ImageSource.gallery);
      if (file == null || !context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoEditor(videoFile: File(file.path)),
        ),
      );
    }

    Future<void> handlePickImageForPost() async {
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null || !context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditPreviewScreen(file: File(file.path)),
        ),
      );
    }

    Future<void> handlePickImageForStory() async {
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null || !context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UploadDecisionScreen(
            file: File(file.path),
            isVideo: false,
            uploadType: 'story',
          ),
        ),
      );
    }

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
              onTap: handlePickVideo,
            ),
            SizedBox(height: 16.h),
            CreateTile(
              icon: Icons.image_rounded,
              title: 'Upload Post',
              subtitle: 'Share image with caption',
              onTap: handlePickImageForPost,
            ),
            SizedBox(height: 16.h),
            CreateTile(
              icon: Icons.auto_stories_rounded,
              title: 'Add Story',
              subtitle: 'Post story for 24 hours',
              onTap: handlePickImageForStory,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}