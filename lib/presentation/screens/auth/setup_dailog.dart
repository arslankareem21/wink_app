import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class SetupPasswordDialog extends ConsumerStatefulWidget {
  const SetupPasswordDialog({super.key});

  @override
  ConsumerState<SetupPasswordDialog> createState() => _SetupPasswordDialogState();
}

class _SetupPasswordDialogState extends ConsumerState<SetupPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.loadingType == AuthLoadingType.setPassword;

    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text('Set Your Password', style: AppTextStyles.authHeadline),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a password to login with email later. You can skip this by canceling.',
                  style: AppTextStyles.authSubtitle,
                ),
                AppSpacing.vsm,
                Text("Password", style: AppTextStyles.inputLabel),
                AppSpacing.vsm,
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Min 6 characters',
                  isPassword: true,
                  prefixIcon: Icon(Icons.lock_outline,
                      color: AppColors.primaryYellow, size: 20.sp),
                  validator: Validators.password,
                ),
                AppSpacing.vsm,
                Text("Confirm Password", style: AppTextStyles.inputLabel),
                AppSpacing.vsm,
                AppTextField(
                  controller: _confirmController,
                  hintText: 'Re-enter password',
                  isPassword: true,
                  prefixIcon: Icon(Icons.lock_outline,
                      color: AppColors.primaryYellow, size: 20.sp),
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: isLoading
                ? null
                : () {
                    ref.read(authViewModelProvider.notifier).cancelPasswordSetup();
                    Navigator.of(context).pop();
                  },
            child: const Text('Cancel'),
          ),
          AppButton(
            text: isLoading ? 'Setting...' : 'Confirm',
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      ref
                          .read(authViewModelProvider.notifier)
                          .setPasswordForGoogleUser(_passwordController.text.trim());
                    }
                  },
          ),
        ],
      ),
    );
  }
}