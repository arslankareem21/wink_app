import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/presentation/components/splash/splash_logo.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/text_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (prev, next) {
      // Fixed: Use message instead of goToLogin
      if (next.message?.contains('Account created') == true) {
        AppSnackBar.show(next.message!);
        NavigationService.go(context, AppRoutes.login);
        ref.read(authViewModelProvider.notifier).clear();
      }
      if (next.error != null && next.error != prev?.error) {
        AppSnackBar.show(next.error!, isError: true);
        ref.read(authViewModelProvider.notifier).clear();
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.loadingType == AuthLoadingType.emailSignup;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Center(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          width: 342.w,
                          padding: AppSpacing.cardPadding,
                          child: Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode
                                .onUserInteraction, // 🌟 Naya Addition
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSpacing.vxl,
                                const Center(child: SplashLogo()),
                                AppSpacing.vsm,
                                Center(
                                  child: Text(
                                    "Create Account",
                                    style: AppTextStyles.authHeadline,
                                  ),
                                ),
                                AppSpacing.vsm,
                                Center(
                                  child: Text(
                                    "Sign up to get started",
                                    style: AppTextStyles.authSubtitle,
                                  ),
                                ),
                                AppSpacing.vsm,
                                Text(
                                  "Your Name",
                                  style: AppTextStyles.inputLabel,
                                ),
                                AppSpacing.vsm,
                                AppTextField(
                                  textInputAction: TextInputAction.next,
                                  controller: nameController,
                                  hintText: 'Enter your name',
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: Validators.name,
                                  inputFormatters: [
                                    //FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    //  Fil
                                    ),
                                  ],
                                ),
                                AppSpacing.vsm,
                                Text(
                                  "Email Address",
                                  style: AppTextStyles.inputLabel,
                                ),
                                AppSpacing.vsm,
                                AppTextField(
                                  textInputAction: TextInputAction.next,

                                  controller: emailController,
                                  hintText: 'Enter your email',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: Validators.email,
                                   inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                ),
                                AppSpacing.vsm,
                                Text(
                                  "Password",
                                  style: AppTextStyles.inputLabel,
                                ),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: passwordController,
                                  hintText: 'Enter your password',
                                  textInputAction: TextInputAction.next,
                                  isPassword: true,
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: Validators.password,
                                   inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                ),
                                AppSpacing.vsm,
                                Text(
                                  "Confirm Password",
                                  style: AppTextStyles.inputLabel,
                                ),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: confirmPasswordController,
                                  textInputAction: TextInputAction.done,
                                  hintText: 'Confirm your password',
                                  isPassword: true,
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: (v) => Validators.confirmPassword(v,passwordController.text,
                                  ), 
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                ),
                                AppSpacing.vsm,
                                AppButton(
                                  width: double.infinity,
                                  text: isLoading
                                      ? "Creating account..."
                                      : "Sign Up",
                                  isGhost: false,
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          if (!formKey.currentState!.validate())
                                            return;
                                          ref
                                              .read(
                                                authViewModelProvider.notifier,
                                              )
                                              .signnupp(emailController.text.trim(),
                                               nameController.text.trim(),
                                               passwordController.text.trim());
                                              
                                        },
                                ),
                                AppSpacing.vsm,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: AppTextStyles.authSubtitle,
                                    ),
                                    AppTextButton(
                                      text: "Login",
                                      textStyle: AppTextStyles.textLink
                                          .copyWith(
                                            color: AppColors.primaryYellow,
                                          ),
                                      // Fixed: Use NavigationService
                                      onPressed: () =>
                                          NavigationService.pop(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
