import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/utils/media_utils.dart';
import 'package:wink_app/viewmodels/upload_vm.dart';

class CreateStory extends ConsumerStatefulWidget {
  const CreateStory({super.key});

  @override
  ConsumerState<CreateStory> createState() => _CreateStoryState();
}

class _CreateStoryState extends ConsumerState<CreateStory> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Create Story",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(250, 50),
              ),
              onPressed: () async {
                final XFile? pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (pickedFile != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (editorContext) => ProImageEditor.file(
                        File(pickedFile.path),
                        callbacks: ProImageEditorCallbacks(
                          onImageEditingComplete: (Uint8List bytes) async {
                            // 1. Pehle byte se file banayein
                            File editedFile = await getFilePathFromBytes(
                              bytes,
                              pickedFile.name,
                            );

                            // 2. Background Upload Trigger Karein (Non-blocking)
                            ref
                                .read(uploadProvider.notifier)
                                .uploadStory(file: editedFile, isVideo: false)
                                .catchError((e) {
                                  if (context.mounted) {
                                    print(e);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Upload failed: $e'),
                                      ),
                                    );
                                  }
                                });

                            // 3. User ko Direct Home Screen par redirect kar dein
                            if (context.mounted) {
                              NavigationService.push(context, AppRoutes.home);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.image_rounded),
              label: const Text(
                "Choose Photo",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            //             ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.white,
            //     foregroundColor: Colors.black,
            //     minimumSize: const Size(250, 50),
            //   ),
            //   onPressed: () async {
            //     final XFile? pickedFile = await _picker.pickImage(
            //       source: ImageSource.gallery,
            //     );

            //     if (pickedFile != null && context.mounted) {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (editorContext) => ProImageEditor.file(
            //             File(pickedFile.path),
            //             callbacks: ProImageEditorCallbacks(
            //               onImageEditingComplete: (Uint8List bytes) async {
            //                 // 1. Convert bytes to File
            //                 File editedFile = await getFilePathFromBytes(
            //                   bytes,
            //                   pickedFile.name,
            //                 );

            //                 // 2. Close the Image Editor Screen immediately so UI doesn't hang
            //                 if (editorContext.mounted) {
            //                   Navigator.pop(editorContext);
            //                 }

            //                 // 3. Trigger upload with try-catch
            //                 try {
            //                   await ref
            //                       .read(uploadProvider.notifier)
            //                       .uploadStory(file: editedFile, isVideo: false);

            //                   // 4. Navigate back to Home screen after successful upload
            //                   if (context.mounted) {
            //                     NavigationService.push(context, AppRoutes.home);
            //                   }
            //                 } catch (e) {
            //                   // Show error snackbar if upload fails
            //                   if (context.mounted) {
            //                     ScaffoldMessenger.of(context).showSnackBar(
            //                       SnackBar(content: Text('Upload failed: $e')),
            //                     );
            //                   }
            //                 }
            //               },
            //             ),
            //           ),
            //         ),
            //       );
            //     }
            //   },
            //   icon: const Icon(Icons.image_rounded),
            //   label: const Text(
            //     "Choose Photo",
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.white,
            //     foregroundColor: Colors.black,
            //     minimumSize: const Size(250, 50),
            //   ),
            //   onPressed: () async {
            //     final XFile? pickedFile = await _picker.pickImage(
            //       source: ImageSource.gallery,
            //     );
            //     if (pickedFile != null && context.mounted) {
            //       // final currentUserId =
            //       //     FirebaseAuth.instance.currentUser?.uid ?? '';
            //       Navigator.push(
            //         context,

            //         MaterialPageRoute(
            //           builder: (ctx) => ProImageEditor.file(
            //             File(pickedFile.path),
            //             callbacks: ProImageEditorCallbacks(
            //               onImageEditingComplete: (Uint8List bytes) async {
            //                 File editedFile = await getFilePathFromBytes(
            //                   bytes,
            //                   pickedFile.name,
            //                 );
            //                 await ref
            //                     .read(uploadProvider.notifier)
            //                     .uploadStory(file: editedFile, isVideo: false);

            //                 if (context.mounted) {
            //                   NavigationService.push(context, AppRoutes.home);
            //                 }
            //               },
            //             ),
            //           ),
            //         ),
            //       );
            //     }
            //   },
            //   icon: const Icon(Icons.image_rounded),
            //   label: const Text(
            //     "Choose Photo",
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            AppSpacing.vxxl,
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(250, 50),
              ),
              onPressed: () async {
                // 1. Pick the video file
                final XFile? pickedFile = await _picker.pickVideo(
                  source: ImageSource.gallery,
                );

                // 2. Upload it directly (Bypassing ProImageEditor)
                if (pickedFile != null && context.mounted) {
                  File videoFile = File(pickedFile.path);

                  // Trigger your upload immediately
                  await ref
                      .read(uploadProvider.notifier)
                      .uploadStory(
                        file: videoFile,
                        isVideo: true, // Mark as true
                      );

                  // 3. Navigate back home
                  if (mounted)
                    return NavigationService.push(
                      context,
                      //MaterialPage)
                      AppRoutes.home,
                    );
                }
              },
              icon: const Icon(Icons.image_rounded),
              label: const Text(
                "Choose Video",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
