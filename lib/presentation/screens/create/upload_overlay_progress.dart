import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/viewmodels/upload_vm.dart';


class UploadProgressOverlay extends ConsumerWidget {
  const UploadProgressOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);

    if (!state.isUploading) return const SizedBox();

    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: state.progress,
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            Text(
              "${(state.progress * 100).toInt()}%",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              state.message ?? "Uploading...",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}