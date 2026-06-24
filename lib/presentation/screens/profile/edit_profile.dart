import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart'; // IMPORT
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/edit_profile_vm.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';
import 'package:wink_app/viewmodels/upload_vm.dart';



class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final pickedFile = ref.watch(imagePickerProvider);
    final uploadState = ref.watch(uploadProvider);
    final editState = ref.watch(editProfileViewModelProvider);

    ref.listen(uploadProvider, (previous, next) {
      if (previous?.isUploading == true && next.isUploading == false && next.error == null) {
        ref.invalidate(currentUserProvider);
      }
    });

    final nameController = useTextEditingController();
    final usernameController = useTextEditingController();
    final bioController = useTextEditingController();
    final websiteController = useTextEditingController();
    final categoryController = useTextEditingController();
    final locationController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final collaborationEmailController = useTextEditingController();

    final isDataLoaded = useState(false);
    final hasNameError = useState(false);
    final originalUsername = useState<String>('');

    final usernameInput = useState('');
    useEffect(() {
      void listener() => usernameInput.value = usernameController.text;
      usernameController.addListener(listener);
      return () => usernameController.removeListener(listener);
    }, [usernameController]);

    final debouncedUsername = useDebounced(usernameInput.value, const Duration(milliseconds: 500));

    final usernameCheck = ref.watch(usernameAvailableProvider((
      username: debouncedUsername?? '',
      uid: currentUserAsync.value?.userId?? '',
    )));

    // Use Validators.username + async exists check
    final usernameError = useMemoized(() {
      final val = (debouncedUsername?? '').trim();

      // 1. Sync validation from Validators
      final syncError = Validators.username(val);
      if (syncError!= null) return syncError;

      // 2. Skip async if keeping own username
      if (val.toLowerCase() == originalUsername.value.toLowerCase()) return null;

      // 3. Async exists check
      if (usernameCheck.isLoading) return 'Checking...';
      if (usernameCheck.hasError) return 'Error checking username';
      if (usernameCheck.hasValue && usernameCheck.value == false) return 'Username already exists';

      return null;
    }, [debouncedUsername, originalUsername.value, usernameCheck]);

    useEffect(() {
      currentUserAsync.whenData((user) {
        if (!isDataLoaded.value && user!= null) {
          nameController.text = user.name;
          usernameController.text = user.username?? '';
          originalUsername.value = user.username?? '';
          bioController.text = user.bio?? '';
          websiteController.text = user.website?? '';
          categoryController.text = user.category?? '';
          locationController.text = user.location?? '';
          descriptionController.text = user.description?? '';
          collaborationEmailController.text = user.collaborationEmail?? '';
          isDataLoaded.value = true;
        }
      });
      return null;
    }, [currentUserAsync]);

    void saveChanges() async {
      final user = currentUserAsync.value;
      if (user == null || user.userId.isEmpty) {
        AppSnackBar.show('Invalid User Session!');
        return;
      }

      if (nameController.text.trim().isEmpty) {
        hasNameError.value = true;
        return;
      }
      hasNameError.value = false;

      if (usernameError!= null) {
        AppSnackBar.show(usernameError!);
        return;
      }

      try {
        await ref.read(editProfileViewModelProvider.notifier).updateProfileData(
          uid: user.userId,
          username: usernameController.text.trim().toLowerCase(),
          bio: descriptionController.text.trim(),
          website: websiteController.text.trim(),
          displayName: nameController.text.trim(),
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
          AppSnackBar.show('Error: ${e.toString().replaceAll('Exception: ', '')}');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile ', style: AppTextStyles.appBarTitle),
        leading: ThemeToggleButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: editState.isLoading || usernameError!= null? null : saveChanges,
              icon: editState.isLoading
                 ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.done),
            ),
          ),
        ],
      ),
      body: currentUserAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          final networkImageUrl = user.profileImageUrl!= null && user.profileImageUrl!.isNotEmpty
             ? '${user.profileImageUrl}?v=${user.updatedAt.millisecondsSinceEpoch}'
              : null;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.vxl,
                Center(
                  child: GestureDetector(
                    onTap: editState.isLoading || uploadState.isUploading
                       ? null
                        : () async {
                            await ref.read(imagePickerProvider.notifier).pickFromGallery();
                            final newFile = ref.read(imagePickerProvider);

                            if (newFile!= null && context.mounted) {
                              try {
                                await ref.read(uploadProvider.notifier).uploadProfilePic(file: newFile);
                                ref.read(imagePickerProvider.notifier).clear();
                                if (context.mounted) AppSnackBar.show('Profile photo updated');
                              } catch (e) {
                                if (context.mounted) AppSnackBar.show('Upload failed: $e');
                              } finally {
                                ref.read(uploadProvider.notifier).reset();
                              }
                            }
                          },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        AppProfileAvatar(
                          key: ValueKey('${pickedFile?.path}_${networkImageUrl}_${user.updatedAt.millisecondsSinceEpoch}'),
                          size: 80.sp,
                          imageSource: pickedFile?.path?? networkImageUrl,
                          isNetwork: pickedFile == null,
                        ),
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                        if (uploadState.isUploading)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: uploadState.progress > 0? uploadState.progress : null,
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
                AppSpacing.vxxl,
                Text("NAME"),
                AppSpacing.vsm,
                AppTextField(
                  hintText: 'Your name',
                  controller: nameController,
                  errorText: hasNameError.value? 'Name is required' : null,
                ),
                AppSpacing.vxxl,
                Text("USERNAME"),
                AppSpacing.vsm,
                AppTextField(
                  hintText: 'Your username',
                  controller: usernameController,
                  errorText: usernameError,
                  suffixIcon: usernameCheck.isLoading
                     ? Padding(
                          padding: EdgeInsets.all(12.w),
                          child: SizedBox(
                            width: 16.sp,
                            height: 16.sp,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : usernameError == null && (debouncedUsername?.isNotEmpty?? false)
                         ? Icon(Icons.check_circle, color: Colors.green, size: 20.sp)
                          : null,
                ),
                AppSpacing.vxxl,
                Text("BIO"),
                AppSpacing.vsm,
                AppTextField(
                  maxLines: 6,
                  hintText: 'BIO',
                  controller: descriptionController,
                  height: 110.h,
                ),
                AppSpacing.vxxl,
                Text("WEBSITE"),
                AppSpacing.vsm,
                AppTextField(hintText: 'Website', controller: websiteController),
                AppSpacing.vxxl,
                Text("COLLABORATIONEMAIL"),
                AppSpacing.vsm,
                AppTextField(hintText: 'collaborationEmail', controller: collaborationEmailController),
                AppSpacing.vxxl,
                Text("CATEGORY"),
                AppSpacing.vsm,
                AppTextField(hintText: 'category', controller: categoryController),
                AppSpacing.vxxl,
                Text("LOCATION"),
                AppSpacing.vsm,
                AppTextField(hintText: 'location', controller: locationController),
                AppSpacing.vxxl,
                Center(
                  child: AppButton(
                    width: 240.w,
                    text: editState.isLoading? 'Saving...' : 'Save Changes',
                    onPressed: editState.isLoading || usernameError!= null? null : saveChanges,
                  ),
                ),
                AppSpacing.vlg,
                Center(
                  child: AppButton(
                    width: 240.w,
                    text: 'Cancel',
                    isGhost: true,
                    onPressed: editState.isLoading? null : () => NavigationService.pop(context),
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