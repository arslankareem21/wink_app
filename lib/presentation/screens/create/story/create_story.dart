

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
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
                  // final currentUserId =
                  //     FirebaseAuth.instance.currentUser?.uid ?? '';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ProImageEditor.file(
                        File(pickedFile.path),
                        callbacks: ProImageEditorCallbacks(
                          onImageEditingComplete: (Uint8List bytes) async {
                            File editedFile = await getFilePathFromBytes(
                              bytes,
                              pickedFile.name,
                            );
                            await ref
                                .read(uploadProvider.notifier)
                                .uploadStory(file: editedFile, isVideo: false);

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
                  if (context.mounted) {
                    NavigationService.push(context, AppRoutes.home);
                  }
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
