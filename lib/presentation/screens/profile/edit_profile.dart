import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';
import 'package:wink_app/viewmodels/profile/edit_profile_vm.dart/edit_profile_vm.dart';
import 'package:wink_app/viewmodels/upload_vm.dart';

class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final uploadState = ref.watch(uploadProvider);
    final editState = ref.watch(editProfileViewModelProvider);

    // Centralized picker state
    final pickedFile = ref.watch(imagePickerProvider);

    final nameController = useTextEditingController();
    final usernameController = useTextEditingController();
    final bioController = useTextEditingController();
    final websiteController = useTextEditingController();
    final categoryController = useTextEditingController();
    final locationController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final collaborationEmailController = useTextEditingController();

    final hasNameError = useState(false);
    final debouncedUsername = useState('');

    // Username debounce
    useEffect(() {
      Timer? timer;
      void listener() {
        timer?.cancel();
        timer = Timer(const Duration(milliseconds: 500), () {
          debouncedUsername.value = usernameController.text.trim();
        });
      }

      usernameController.addListener(listener);
      return () {
        usernameController.removeListener(listener);
        timer?.cancel();
      };
    }, [usernameController]);

    final currentUser = currentUserAsync.value;
    final isNewUsername =
        currentUser != null &&
        debouncedUsername.value.toLowerCase() !=
            currentUser.username?.toLowerCase();

    final usernameCheckAsync = isNewUsername
        ? ref.watch(isUsernameTakenProvider(debouncedUsername.value))
        : const AsyncValue.data(false);

    final isUsernameTaken = usernameCheckAsync.value ?? false;

    // Pre-fill user data
    useEffect(() {
      if (currentUserAsync.value != null) {
        final user = currentUserAsync.value!;
        nameController.text = user.name;
        usernameController.text = user.username ?? '';
        bioController.text = user.bio ?? '';
        websiteController.text = user.website ?? '';
        categoryController.text = user.category ?? '';
        locationController.text = user.location ?? '';
        descriptionController.text = user.description ?? '';
        collaborationEmailController.text = user.collaborationEmail ?? '';
      }
      return () {
        nameController.clear();
        usernameController.clear();
        bioController.clear();
        websiteController.clear();
        categoryController.clear();
        locationController.clear();
        descriptionController.clear();
        collaborationEmailController.clear();
      };
    }, [currentUserAsync.value]);

    void saveChanges() async {
      final user = currentUserAsync.value;

      if (user == null || user.userId.isEmpty) {
        AppSnackBar.show('Invalid User Session!');
        return;
      }

      // if (nameController.text.trim().isEmpty) {
      //   hasNameError.value = true;
      //   return;
      // }

      // hasNameError.value = false;
      // if (isUsernameTaken) {
      //   AppSnackBar.show('Please change your username before saving.');
      //   return;
      // }
      // 1. Name Check: Agar controller khali hai toh purana name le lo, warna controller ka text
      final String updatedName = nameController.text.trim().isEmpty
          ? (user.name ?? '')
          : nameController.text.trim();

      // Agar user ka purana name bhi nahi tha aur abhi bhi khali hai, tabhi block karein
      if (updatedName.isEmpty) {
        hasNameError.value = true;
        AppSnackBar.show('Name cannot be empty!');
        return;
      }
      hasNameError.value = false;

      // 2. Username Check
      if (isUsernameTaken) {
        AppSnackBar.show('Please change your username before saving.');
        return;
      }
      try {
        await ref
            .read(editProfileViewModelProvider.notifier)
            .updateProfileData(
              uid: user.userId,
              username: usernameController.text.trim(),
              bio: descriptionController.text.trim(),
              website: websiteController.text.trim(),
              displayName: updatedName,
              category: categoryController.text.trim(),
              collaborationEmail: collaborationEmailController.text.trim(),
              location: locationController.text.trim(),
            );
        if (context.mounted) {
          AppSnackBar.show('Profile updated successfully');
          NavigationService.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          AppSnackBar.show(
            'Error: ${e.toString().replaceAll('Exception: ', '')}',
          );
        }
      }
    }

    Future<void> pickAndUploadProfilePic() async {
      if (editState.isLoading || uploadState.isUploading) return;

      await ref.read(imagePickerProvider.notifier).pickFromGallery();
      final file = ref.read(imagePickerProvider);
      if (file == null || !context.mounted) return;

      //   try {
      //     await ref.read(uploadProvider.notifier)
      //     .uploadProfilePic(file: file);
      //     ref.invalidate(currentUserProvider);
      //     if (context.mounted) AppSnackBar.show('Profile photo updated');
      //   } catch (e) {
      //     if (context.mounted) AppSnackBar.show('Upload failed: $e');
      //   } finally {
      //     ref.read(imagePickerProvider.notifier).clear();
      //     ref.read(uploadProvider.notifier).reset();
      //   }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTextStyles.appBarTitle),
        leading: ThemeToggleButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: editState.isLoading ? null : saveChanges,
              icon: editState.isLoading
                  ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.done),
            ),
          ),
        ],
      ),
      body: currentUserAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          final networkImageUrl =
              user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
              ? user.profileImageUrl
              : null;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.vxl,
                Center(
                  child: GestureDetector(
                    onTap: pickAndUploadProfilePic,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // AppProfileAvatar(
                        //   size: 80.sp,
                        //   imageSource: pickedFile?.path ?? networkImageUrl,
                        //   isNetwork: pickedFile == null,
                        //   radius: 40,
                        //),
                        // EditProfileScreen.dart
                        AppProfileAvatar(
                          radius: 40,
                          size: 80.sp,
                          imageFile: pickedFile, // 👈 Gallery File pass karein
                          imageSource:
                              networkImageUrl, // 👈 Network URL pass karein
                        ),
                        Positioned(
                          bottom: 2,
                          right: -1,
                          child: Container(
                            height: 32,
                            width: 32,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryYellow,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        if (uploadState.isUploading)
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: uploadState.progress > 0
                                      ? uploadState.progress
                                      : null,
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.vsm,
                Center(
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
                AppSpacing.vxxl,
                Text("NAME"),
                AppSpacing.vsm,
                AppTextField(
                  textInputAction: TextInputAction.next,
                  hintText: 'Your name',
                  controller: nameController,
                  errorText: hasNameError.value ? 'Name is required' : null,
                ),
                AppSpacing.vxxl,
                Text("USERNAME"),
                AppSpacing.vsm,
                AppTextField(
                  textInputAction: TextInputAction.next,
                  hintText: 'Your username',
                  controller: usernameController,
                  validator: Validators.username,
                  errorText: isUsernameTaken
                      ? 'This username is already taken'
                      : null,
                  suffixIcon: usernameCheckAsync.isLoading
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : isUsernameTaken
                      ? const Icon(Icons.error_outline, color: Colors.red)
                      : usernameController.text.isNotEmpty && isNewUsername
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        )
                      : null,
                ),
                AppSpacing.vxxl,
                Text("BIO"),
                AppSpacing.vsm,
                AppTextField(
                  textInputAction: TextInputAction.next,
                  maxLines: 6,
                  hintText: 'BIO',
                  controller: descriptionController,
                  height: 110.h,
                ),
                AppSpacing.vxxl,
                Text("WEBSITE"),
                AppSpacing.vsm,
                AppTextField(
                  textInputAction: TextInputAction.next,
                  hintText: 'Website',
                  controller: websiteController,
                ),
                AppSpacing.vxxl,
                Text("COLLABORATION EMAIL"),
                AppSpacing.vsm,
                AppTextField(
                  textInputAction: TextInputAction.next,
                  hintText: 'collaborationEmail',
                  controller: collaborationEmailController,
                ),
                AppSpacing.vxxl,
                Text("CATEGORY"),
                AppSpacing.vsm,
                AppTextField(
                  textInputAction: TextInputAction.next,
                  hintText: 'category',
                  controller: categoryController,
                ),
                AppSpacing.vxxl,
                Text("LOCATION"),
                AppSpacing.vsm,
                AppTextField(
                  textInputAction: TextInputAction.done,
                  hintText: 'location',
                  controller: locationController,
                ),
                AppSpacing.vxxl,
                Center(
                  child: AppButton(
                    width: 240.w,
                    text: editState.isLoading ? 'Saving...' : 'Save Changes',
                    onPressed: editState.isLoading ? null : saveChanges,
                  ),
                ),
                AppSpacing.vlg,
                Center(
                  child: AppButton(
                    width: 240.w,
                    text: 'Cancel',
                    isGhost: true,
                    onPressed: editState.isLoading
                        ? null
                        : () => NavigationService.pop(context),
                  ),
                ),
                AppSpacing.vxxl,
              ],
            ),
          );
        },
      ),
    );
  }
}
