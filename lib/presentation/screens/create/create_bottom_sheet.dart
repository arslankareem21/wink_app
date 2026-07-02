// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:wink_app/core/config/routes/navigation_service.dart';
// import 'package:wink_app/core/config/routes/route_names.dart';
// import 'package:wink_app/presentation/screens/create/edit-video_screen.dart';
// import 'package:wink_app/presentation/screens/create/story/create_story.dart';
// import 'package:wink_app/presentation/widgets/create_tile.dart';
// import 'package:wink_app/viewmodels/image_picker_vm.dart';

// import '../../../../core/config/theme/app_colors.dart';

// class CreateBottomSheet extends ConsumerWidget {
//   const CreateBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context, ref) {
//     final pickedFile = ref.watch(imagePickerProvider);
//     return SafeArea(
//       child: Container(
//         padding: EdgeInsets.all(24.w),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: 5.h,
//               width: 60.w,
//               decoration: BoxDecoration(
//                 color: AppColors.greyDark,
//                 borderRadius: BorderRadius.circular(100.r),
//               ),
//             ),

//             SizedBox(height: 28.h),

//             CreateTile(
//               icon: Icons.video_collection_rounded,
//               title: 'Create Short',
//               subtitle: 'Upload or record short videos',
//               onTap: () async {
//                 await ref
//                     .read(imagePickerProvider.notifier)
//                     .pickVideoFromGallery();
//                 if (!context.mounted) return;

//                 final pickedFile = ref.read(imagePickerProvider);
//                 if (pickedFile == null) return;
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => VideoEditor(videoFile: pickedFile),
//                   ),
//                 );
//               },
//             ),

//             SizedBox(height: 16.h),

//             CreateTile(
//               icon: Icons.image_rounded,
//               title: 'Upload Post',
//               subtitle: 'Share image with caption',
//               onTap: () {},
//             ),

//             SizedBox(height: 16.h),

//             CreateTile(
//               icon: Icons.auto_stories_rounded,
//               title: 'Add Story',
//               subtitle: 'Post story for 24 hours',
//               onTap: () async {
//                 await ref.read(imagePickerProvider.notifier).pickFromGallery();

//                 final PickedFile = ref.read(imagePickerProvider);
//                 if (pickedFile == null) return;

//                 NavigationService.push(context, AppRoutes.createStory);

//                 //                 ElevatedButton.icon(
//                 //   onPressed: () => _pickVideoFromGallery(context),
//                 //   icon: const Icon(Icons.video_library),
//                 //   label: const Text("Select Video to Edit"),
//                 // )
//               },
//             ),

//             SizedBox(height: 20.h),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/presentation/screens/create/edit-video_screen.dart';
import 'package:wink_app/presentation/screens/create/edit_preview.dart';
import 'package:wink_app/presentation/screens/create/edit_preview_screen.dart';
import 'package:wink_app/presentation/screens/create/image_picker_screen.dart';
import 'package:wink_app/presentation/screens/create/video_edit_screen.dart'
    hide VideoEditor;
import 'package:wink_app/presentation/widgets/create_tile.dart';
import 'package:wink_app/presentation/widgets/imagepicker_bottomsheet.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';

import '../../../../core/config/theme/app_colors.dart';

class CreateBottomSheet extends ConsumerWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final pickedFile = ref.watch(imagePickerProvider);

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
              onTap: () async {
                await ref
                    .read(imagePickerProvider.notifier)
                    .pickVideoFromGallery();
                if (!context.mounted) return;

                final pickedFile = ref.read(imagePickerProvider);
                if (pickedFile == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoEditor(videoFile: pickedFile),
                  ),
                );
              },
            ),

            SizedBox(height: 16.h),

            CreateTile(
              icon: Icons.image_rounded,
              title: 'Upload Post',
              subtitle: 'Share image with caption',
              onTap: () async {
                await ref.read(imagePickerProvider.notifier).pickFromGallery();
                if (!context.mounted) return;

                final pickedFile = ref.read(imagePickerProvider);
                if (pickedFile == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditPreviewScreen(file: pickedFile),
                  ),
                );
              },
            ),

            SizedBox(height: 16.h),

            CreateTile(
              icon: Icons.auto_stories_rounded,
              title: 'Add Story',
              subtitle: 'Post story for 24 hours',
              onTap: () async {
                await ref.read(imagePickerProvider.notifier).pickFromGallery();

                final PickedFile = ref.read(imagePickerProvider);
                if (pickedFile == null) return;

                if (context.mounted) {
                  NavigationService.push(context, AppRoutes.createStory);
                }
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
