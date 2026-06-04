<<<<<<< HEAD
=======
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:wink_app/core/config/theme/app_colors.dart';
// import 'package:wink_app/core/config/theme/app_spacing.dart';
// import 'package:wink_app/core/config/theme/app_text_style.dart';
// import 'package:wink_app/core/utils/validators.dart';
// import 'package:wink_app/presentation/components/splash/splash_logo.dart';
// import 'package:wink_app/presentation/screens/auth/forget_password_screen.dart';
// import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
// import 'package:wink_app/presentation/widgets/elevated_button.dart';
// import 'package:wink_app/presentation/widgets/text_button.dart';
// import 'package:wink_app/presentation/widgets/textformfield.dart';
// import 'package:wink_app/viewmodels/auth_viewmodel.dart';

// class LoginScreen extends HookConsumerWidget {
//   // Marked as final to prevent re-instantiation on widget rebuilds
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Watch auth state to handle loading indicators safely
//     final authState = ref.watch(authProvider);
//     final isLoading = authState.isLoading;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Padding(
//                     padding: AppSpacing.cardPadding,
//                     child: Center(
//                       child: Card(
//                         elevation: 4,
//                         child: Container(
//                           width: 342.w,
//                           padding: AppSpacing.cardPadding,
//                           child: Form(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 AppSpacing.vxl,
//                                 const Center(
//                                   child: SizedBox(
//                                     height: 50,
//                                     child: SplashLogo(),
//                                   ),
//                                 ),
//                                 AppSpacing.vsm,
//                                 Center(
//                                   child: Text(
//                                     "Welcome Back!",
//                                     style: AppTextStyles.authHeadline,
//                                   ),
//                                 ),
//                                 AppSpacing.vsm,
//                                 Center(
//                                   child: Text(
//                                     "Please login to your account",
//                                     style: AppTextStyles.authSubtitle,
//                                   ),
//                                 ),
//                                 AppSpacing.vsm,
//                                 Text(
//                                   "Email Address",
//                                   textAlign: TextAlign.left,
//                                   style: AppTextStyles.inputLabel,
//                                 ),
//                                 AppSpacing.vsm,
//                                 AppTextField(
//                                   controller: emailController,
//                                   hintText: 'Enter your email',
//                                   prefixIcon: Icon(
//                                     Icons.email_outlined,
//                                     color: AppColors.primaryYellow,
//                                     size: 20.sp,
//                                   ),
//                                   keyboardType: TextInputType.emailAddress,
//                                   textInputAction: TextInputAction.next,
//                                   validator: Validators.email,
//                                 ),
//                                 AppSpacing.vsm,
//                                 Text(
//                                   "Password",
//                                   textAlign: TextAlign.left,
//                                   style: AppTextStyles.inputLabel,
//                                 ),
//                                 AppSpacing.vsm,
//                                 AppTextField(
//                                   hintText: 'Enter your password',
//                                   controller: passwordController,
//                                   isPassword: true,
//                                   prefixIcon: Icon(
//                                     Icons.lock_outline,
//                                     color: AppColors.primaryYellow,
//                                     size: 20.sp,
//                                   ),
//                                   textInputAction: TextInputAction.done,
//                                   validator: Validators.password,
//                                 ),
//                                 AppSpacing.vsm,
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: AppTextButton(
//                                     height: 40.h,
//                                     text: "Forgot Password?",
//                                     textStyle: AppTextStyles.textLink.copyWith(
//                                       fontSize: 14.sp,
//                                     ),
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (_) => const ForgetPasswordScreen()),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 AppSpacing.vsm,
//                                 AppButton(
//                                   text: isLoading ? "Logging in..." : "Login",
//                                   isGhost: false,
//                                   width: double.infinity,
//                                   onPressed: isLoading
//                                       ? null
//                                       : () {
//                                           ref.read(authProvider.notifier).login(
//                                                 emailController.text,
//                                                 passwordController.text,
//                                                 context,
//                                               );
//                                         },
//                                 ),
//                                 AppSpacing.vsm,
//                                 Row(
//                                   children: [
//                                     AppSpacing.hxxxl,
//                                     Expanded(child: Divider(height: 1.h)),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: 8.w),
//                                       child: Text(
//                                         'or continue with',
//                                         style: AppTextStyles.authSubtitle,
//                                       ),
//                                     ),
//                                     Expanded(child: Divider(height: 2.h)),
//                                     AppSpacing.hxxxl,
//                                   ],
//                                 ),
//                                 AppSpacing.vsm,
//                                 Center(
//                                   child: AppButton(
//                                     width: 240.w,
//                                     text: isLoading ? "Signing in..." : 'Continue with Google',
//                                     isGhost: true,
//                                     onPressed: isLoading
//                                         ? null
//                                         : () {
//                                             ref
//                                                 .read(authProvider.notifier)
//                                                 .signInWithGoogle(context);
//                                           },
//                                     icon: SvgPicture.asset('assets/icon/google.svg'),
//                                   ),
//                                 ),
//                                 AppSpacing.vsm,
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "Don't have an account?",
//                                       style: AppTextStyles.authSubtitle,
//                                     ),
//                                     AppTextButton(
//                                       text: "Sign Up",
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (_) => const SignUpScreen(),
//                                           ),
//                                         );
//                                       },
//                                       textStyle: AppTextStyles.textLink.copyWith(
//                                         color: AppColors.primaryYellow,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }




//------------------------------------------


>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
<<<<<<< HEAD
=======
import 'package:hooks_riverpod/hooks_riverpod.dart';

>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
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
<<<<<<< HEAD
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class LoginScreen extends ConsumerWidget {
=======
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class LoginScreen extends HookConsumerWidget {
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
<<<<<<< HEAD
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
=======
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final authState = ref.watch(authProvider);
    final isLoading = authState.loading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
<<<<<<< HEAD
                  minHeight: constraints.maxHeight, // 2. Fill screen height
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: AppSpacing.cardPadding, // 3. Use padding instead of margin
                    child: Center( // 4. Center the card vertically
=======
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Center(
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
                      child: Card(
                        elevation: 4,
                        child: Container(
                          width: 342.w,
                          padding: AppSpacing.cardPadding,
                          child: Form(
<<<<<<< HEAD
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
=======
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppSpacing.vxl,
                                const Center(child: SplashLogo()),
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
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
<<<<<<< HEAD
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
=======

                                AppSpacing.vsm,
                                Text("Email Address",
                                    style: AppTextStyles.inputLabel),
                                AppSpacing.vsm,

                                AppTextField(
                                  controller: emailController,
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
<<<<<<< HEAD
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
=======
                                  validator: Validators.email,
                                ),

                                AppSpacing.vsm,
                                Text("Password",
                                    style: AppTextStyles.inputLabel),
                                AppSpacing.vsm,

                                AppTextField(
                                  controller: passwordController,
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
                                  hintText: 'Enter your password',
                                  isPassword: true,
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
<<<<<<< HEAD
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
=======
                                  validator: Validators.password,
                                ),

                                AppSpacing.vsm,
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: AppTextButton(
                                    text: "Forgot Password?",
                                    textStyle: AppTextStyles.textLink,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgetPasswordScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                AppSpacing.vsm,
                                AppButton(
                                  text: isLoading
                                      ? "Logging in..."
                                      : "Login",
                                  isGhost: false,
                                  width: double.infinity,
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          ref
                                              .read(authProvider.notifier)
                                              .login(
                                                emailController.text.trim(),
                                                passwordController.text.trim(),
                                              );
                                        },
                                ),

                                AppSpacing.vsm,

                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w),
                                      child: Text(
                                        "or continue with",
                                        style: AppTextStyles.authSubtitle,
                                      ),
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),

                                AppSpacing.vsm,

                                Center(
                                  child: AppButton(
                                    width: 240.w,
                                    text: isLoading
                                        ? "Signing in..."
                                        : "Continue with Google",
                                    isGhost: true,
                                    icon: SvgPicture.asset(
                                      'assets/icon/google.svg',
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            ref
                                                .read(authProvider.notifier)
                                                .googleLogin();
                                          },
                                  ),
                                ),

                                AppSpacing.vsm,

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: AppTextStyles.authSubtitle,
                                    ),
                                    AppTextButton(
                                      text: "Sign Up",
                                      textStyle: AppTextStyles.textLink.copyWith(
                                        color: AppColors.primaryYellow,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SignUpScreen(),
                                          ),
                                        );
                                      },
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
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