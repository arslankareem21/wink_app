import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/viewmodels/upload_vm.dart';


class UploadProgressOverlay extends ConsumerWidget {
  const UploadProgressOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show snackbar on error
    ref.listen(uploadProvider, (prev, next) {
      if (prev?.error == null && next.error!= null) {
        AppSnackBar.show( next.error!, isError: true);
        // Reset state after showing error
        Future.delayed(const Duration(milliseconds: 100), () {
          if (ref.context.mounted) {
            ref.read(uploadProvider.notifier).state =
                UploadState(isUploading: false, progress: 0);
          }
        });
      }
    });

    final uploadState = ref.watch(uploadProvider);

    // Only show overlay while uploading
    if (!uploadState.isUploading) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  uploadState.message?? "Uploading...",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: uploadState.progress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Text(
                  "${(uploadState.progress * 100).toInt()}%",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}