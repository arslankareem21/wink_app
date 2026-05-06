import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/presentation/components/splash/splash_logo.dart';
import 'package:wink_app/presentation/screens/auth/forget_password_screen.dart';
import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/text_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(loginViewModelProvider.notifier);
    final state = ref.watch(loginViewModelProvider);

    ref.listen(loginViewModelProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        vm.clearError();
      }
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!)),
        );
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true, // 1. Allow scaffold to resize with keyboard
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // 2. Fill screen height
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: AppSpacing.cardPadding, // 3. Use padding instead of margin
                    child: Center( // 4. Center the card vertically
                      child: Card(
                        elevation: 4,
                        child: Container(
                          width: 342.w,
                          padding: AppSpacing.cardPadding,
                          child: Form(
                            key: vm.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSpacing.vxl,
                                const Center(
                                  child: SizedBox(
                                    height: 50,
                                    child: SplashLogo(),
                                  ),
                                ),
                                AppSpacing.vsm,
                                Center(
                                  child: Text(
                                    "Welcome Back!",
                                    style: AppTextStyles.authHeadline,
                                  ),
                                ),
                                AppSpacing.vsm,
                                Center(
                                  child: Text(
                                    "Please login to your account",
                                    style: AppTextStyles.authSubtitle,
                                  ),
                                ),
                                AppSpacing.vsm,
                                // Email
                                Text(
                                  "Email Address",
                                  textAlign: TextAlign.left,
                                  style: AppTextStyles.inputLabel,
                                ),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: vm.emailController,
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.email,
                                  onFieldSubmitted: (value) => vm.login(),
                                ),
                                
                                AppSpacing.vsm,
                                
                                // Password
                                Text(
                                  "Password",
                                  textAlign: TextAlign.left,
                                  style: AppTextStyles.inputLabel,
                                ),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: vm.passwordController,
                                  hintText: 'Enter your password',
                                  isPassword: true,
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  validator: Validators.password,
                                  onFieldSubmitted: (value) => vm.login(),
                                ),
                                AppSpacing.vsm,
                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: AppTextButton(
                                    height: 40.h,
                                    text: "Forgot Password?",
                                    textStyle: AppTextStyles.textLink.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                    onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen()));
                                    },
                                  ),
                                ),
                                AppSpacing.vsm,
                                
                                // Login Button
                                AppButton(
                                  text: state.isLoading ? 'Logging in...' : 'Login',
                                  isGhost: false,
                                  width: double.infinity,
                                  onPressed: state.isLoading ? null : vm.login,
                                ),
                            
                                AppSpacing.vsm,
                                Row(
                                  children: [
                                    AppSpacing.hxxxl,
                                    Expanded(child: Divider(height: 1.h)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Text('or continue with', style: AppTextStyles.authSubtitle),
                                    ),
                                    Expanded(child: Divider(height: 2.h)),
                                    AppSpacing.hxxxl,
                                  ],
                                ),
                      
                                AppSpacing.vsm,
                                Center(
                                  child: AppButton(
                                    width: 240.w,
                                    text: 'Continue with Google',
                                    isGhost: true, 
                                    onPressed: () {},
                                    icon: SvgPicture.asset('assets/icon/google.svg'),
                                  ),
                                ),
                                AppSpacing.vsm,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account?", style: AppTextStyles.authSubtitle),
                                    AppTextButton(
                                      text: "Sign Up",
                                      onPressed: () {
                                        Navigator.push(context,
                                         MaterialPageRoute(builder: (_) => SignUpScreen(),
                                         ),
                                         );
                                      },
                                      textStyle: AppTextStyles.textLink.copyWith(
                                        color: AppColors.primaryYellow,
                                        fontWeight: FontWeight.bold,
                                      ),
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