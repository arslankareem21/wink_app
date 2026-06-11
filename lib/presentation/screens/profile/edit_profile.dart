import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/edit_profile/edit_profile_form_field.dart';
import 'package:wink_app/presentation/components/profile/edit_profile/edit_profile_header.dart';
import 'package:wink_app/presentation/components/profile/edit_profile/edit_profile_photo.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  // Form State
  bool _hasNameError = false;
  String? _nameErrorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current user data
    _nameController.text = 'Alex Rivera';
    _usernameController.text = 'arivera_vibe';
    _bioController.text =
        'Digital creator & urban explorer. Sharing the best of city life one frame at a time. 🌆';
    _websiteController.text = 'https://alexrivera.me';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      if (_nameController.text.trim().isEmpty) {
        _hasNameError = true;
        _nameErrorText = 'Name is required';
      } else {
        _hasNameError = false;
        _nameErrorText = null;
      }
    });
  }

  Future<void> _saveChanges() async {
    _validateForm();

    if (_hasNameError) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: AppColors.primaryYellow,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      );

      // Navigate back
      Navigator.of(context).pop();
    }
  }

  void _cancelChanges() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Discard Changes?',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.white
                : AppColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to discard your changes?',
          style: TextStyle(color: AppColors.greyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Keep Editing',
              style: TextStyle(color: AppColors.primaryYellow),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header
      appBar: AppBar(
        title: Text('Edit Profile ',style: AppTextStyles.appBarTitle,),
        leading: ThemeToggleButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.done, size: 20.sp),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.vxl,

            // Profile Photo Section
            Center(
              child: ProfilePhotoSection(
                onChangePhoto: () {
                  // Open image picker
                  _showImagePickerOptions();
                },
              ),
            ),

            AppSpacing.vxxl,

            // Name Field
            Text(
              "NAME",
              textAlign: TextAlign.left,
            ),            AppSpacing.vsm,

            AppTextField(hintText: 'Your name', controller: _nameController),
            AppSpacing.vxxl,

            // Username Field
            Text(
              "USERNAME",
              textAlign: TextAlign.left,
            ),            AppSpacing.vsm,

            AppTextField(
              hintText: 'Your username',
              controller: _usernameController,
            ),
            AppSpacing.vxxl,

            // Bio Field
            Text(
              "BIO",
              textAlign: TextAlign.left,
            ),            AppSpacing.vsm,

            AppTextField(
              maxLines: 6,
              hintText: 'BIO', controller: _bioController,
              height: 110.h,),

            AppSpacing.vxxl,

            // Website Field
            Text(
              "WEBSITE FIELD",
              textAlign: TextAlign.left,
            ),
            AppSpacing.vsm,
            AppTextField(hintText: 'Website', controller: _websiteController),

            AppSpacing.vxxl,

            // Action Buttons
            Positioned(
              right: 0,
              left: 0,
              child: Center(
                // ✅ ADD THIS
                child: AppButton(
                  width: 240.w,
                  text: 'Save Changes',
                  isGhost: false,
                  onPressed: () {},
                ),
              ),
            ),
            AppSpacing.vlg,

            Positioned(
              right: 0,
              left: 0,
              child: Center(
                // ✅ ADD THIS
                child: AppButton(
                  width: 240.w,
                  text: 'Cancel',
                  isGhost: true,
                  onPressed: () {},
                ),
              ),
            ),

            AppSpacing.vxxl,
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => SafeArea(
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
                  color: AppColors.greyText.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              AppSpacing.vlg,

              // Take Photo Option
              ListTile(
                leading: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primaryYellow,
                  size: 24.sp,
                ),
                title: Text(
                  'Take Photo',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement camera
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement gallery picker
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
                  Navigator.of(context).pop();
                  // Implement remove photo
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
