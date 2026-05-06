import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/presentation/components/splash/splash_logo.dart';
import 'package:wink_app/presentation/screens/auth/login_screen.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/text_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true, // 1. Allow scaffold to resize with keyboard
      body: SafeArea(
        child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: IntrinsicHeight(
                child: Padding(
                  padding: AppSpacing.cardPadding, // 3. Use padding instead of margin
                  child: Center( // 4. Center the card vertically
                    child: Card(
                      elevation: 3,
                      child: Container(
                        width: 342.w,
                        padding: AppSpacing.cardPadding,
                        child: Form(
                          
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
                                  "Create an Account",
                                  style: AppTextStyles.authHeadline,
                                ),
                              ),
                              AppSpacing.vsm,
                              Center(
                                child: Text(
                                  "Please create an account to get started",
                                  style: AppTextStyles.authSubtitle,
                                ),
                              ),
                              AppSpacing.vsm,
                              // Email
                              Text(
                                "Your Name",
                                textAlign: TextAlign.left,
                                style: AppTextStyles.inputLabel,
                              ),
                              AppSpacing.vsm,
                              AppTextField(
                                controller:nameController,
                                hintText: 'Enter your name',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: AppColors.primaryYellow,
                                  size: 20.sp,
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: Validators.name,
                                //onFieldSubmitted: (value) => vm.login(),
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
                                //controller: vm.emailController,
                                hintText: 'Enter your email',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: AppColors.primaryYellow,
                                  size: 20.sp,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: Validators.email,
                                //onFieldSubmitted: (value) => vm.login(),
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
                                controller: passwordController,
                                hintText: 'Enter your password',
                                isPassword: true,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primaryYellow,
                                  size: 20.sp,
                                ),
                                textInputAction: TextInputAction.done,
                                validator: Validators.password,
                                //onFieldSubmitted: (value) => vm.login(),
                              ),
                              AppSpacing.vsm,
                              Text(
                                "Confirm Password",
                                textAlign: TextAlign.left,
                                style: AppTextStyles.inputLabel,
                              ),
                              AppSpacing.vsm,
                              AppTextField(
                                controller: confirmPasswordController,
                                hintText: 'Confirm your password',
                                isPassword: true,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primaryYellow,
                                  size: 20.sp,
                                ),
                                textInputAction: TextInputAction.done,
                                 validator: (value) => Validators.confirmPassword(
                                 value,
                                  passwordController.text,
                                   ),
                                //onFieldSubmitted: (value) => vm.login(),
                              ),
                              AppSpacing.vxl,
                              Padding(
                                padding: AppSpacing.screenPadding,
                                child: Text("By signing up, you agree to our Terms and PrivacyPolicy."
                                
                                , style: AppTextStyles.legalText,),
                              ),
                              AppSpacing.vsm,
                              AppButton(
                               // text: state.isLoading ? 'Creating account...' : 'Sign Up',
                                isGhost: false,
                                width: double.infinity,
                                text: 'SignUp',
                                onPressed: () {
                                  
                                },
                              ),
              
                          
                              AppSpacing.vsm,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an account?", style: AppTextStyles.authSubtitle),
                                  AppTextButton(
                                    text: "Login",
                                    onPressed: () {
                                     Navigator.pop(context, MaterialPageRoute(builder: (_) => LoginScreen()));
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
         
      ),
    );
  }
}