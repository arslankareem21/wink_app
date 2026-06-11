import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';

import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedFile = ref.watch(imagePickerProvider);
    final authState = ref.watch(authViewModelProvider);

    return Column(
      children: [
        Center(
          child: AppProfileAvatar(
            size: 400,
            imageSource: pickedFile,
            isNetwork: pickedFile == null,
            onTap: () {
              ref.read(imagePickerProvider.notifier).pickFromGallery();
            },
          ),
        ),
        IconButton(
          icon: authState.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.logout, size: 30),
          onPressed: authState.isLoading
              ? null
              : () async {
                  await ref.read(authViewModelProvider.notifier).signOut();
                  if (context.mounted) {
                    NavigationService.go(context, AppRoutes.login);
                  }
                },
        ),
      ],
    );
  }
}