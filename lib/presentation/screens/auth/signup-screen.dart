<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
=======
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:wink_app/core/config/theme/app_colors.dart';
// import 'package:wink_app/core/config/theme/app_spacing.dart';
// import 'package:wink_app/core/config/theme/app_text_style.dart';
// import 'package:wink_app/core/utils/validators.dart';
// import 'package:wink_app/presentation/components/splash/splash_logo.dart';
// import 'package:wink_app/presentation/screens/auth/login_screen.dart';
// import 'package:wink_app/presentation/widgets/elevated_button.dart';
// import 'package:wink_app/presentation/widgets/text_button.dart';
// import 'package:wink_app/presentation/widgets/textformfield.dart';
// import 'package:wink_app/viewmodels/auth_viewmodel.dart';
// import 'package:wink_app/viewmodels/signup_viewmodel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUpScreen extends StatefulHookConsumerWidget {
//   const SignUpScreen({super.key});

//   @override
//   ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
// }

// // FIX: Change 'State<SignUpScreen>' to 'ConsumerState<SignUpScreen>'
// class _SignUpScreenState extends ConsumerState<SignUpScreen> {
//   final fullnameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final usernameController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   // void saveData() {
//   //   String name = fullnameController.text.trim();
//   //   String email = emailController.text.trim();
//   //   String username = usernameController.text.trim();

//   //   fullnameController.clear();
//   //   emailController.clear();
//   //   usernameController.clear();
//   //   if (name != "" && email != "" && username != "") {
//   //     Map<String, dynamic> userData = {
//   //       "name": name,
//   //       "email": email,
//   //       "username": username,
//   //     };
//   //     FirebaseFirestore.instance.collection("users").add(userData);

//   //     print('user created');
//   //   } else {
//   //     print('please fill');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset:
//           true, // 1. Allow scaffold to resize with keyboard
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: IntrinsicHeight(
//             child: Padding(
//               padding:
//                   AppSpacing.cardPadding, // 3. Use padding instead of margin
//               child: Center(
//                 // 4. Center the card vertically
//                 child: Card(
//                   elevation: 3,
//                   child: Container(
//                     width: 342.w,
//                     padding: AppSpacing.cardPadding,
//                     child: Form(
//                       key: formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppSpacing.vxl,
//                           const Center(
//                             child: SizedBox(height: 50, child: SplashLogo()),
//                           ),
//                           AppSpacing.vsm,
//                           Center(
//                             child: Text(
//                               "Create an Account",
//                               style: AppTextStyles.authHeadline,
//                             ),
//                           ),
//                           AppSpacing.vsm,
//                           Center(
//                             child: Text(
//                               "Please create an account to get started",
//                               style: AppTextStyles.authSubtitle,
//                             ),
//                           ),
//                           AppSpacing.vsm,
//                           // Email
//                           Text(
//                             "Your Name",
//                             textAlign: TextAlign.left,
//                             style: AppTextStyles.inputLabel,
//                           ),
//                           AppSpacing.vsm,
//                           AppTextField(
//                             controller: fullnameController,
//                             hintText: 'Enter your name',
//                             prefixIcon: Icon(
//                               Icons.person_outline,
//                               color: AppColors.primaryYellow,
//                               size: 20.sp,
//                             ),
//                             keyboardType: TextInputType.text,
//                             textInputAction: TextInputAction.next,
//                             validator: Validators.name,
//                             //onFieldSubmitted: (value) => vm.login(),
//                           ),
//                           AppSpacing.vsm,
//                           // Email
//                           Text(
//                             "Email Address",
//                             textAlign: TextAlign.left,
//                             style: AppTextStyles.inputLabel,
//                           ),
//                           AppSpacing.vsm,
//                           AppTextField(
//                             controller: emailController,
//                             hintText: 'Enter your email',
//                             prefixIcon: Icon(
//                               Icons.email_outlined,
//                               color: AppColors.primaryYellow,
//                               size: 20.sp,
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                             textInputAction: TextInputAction.next,
//                             validator: Validators.email,
//                             //onFieldSubmitted: (value) => vm.login(),
//                           ),

//                           AppSpacing.vsm,

//                           // Password
//                           Text(
//                             "Password",
//                             textAlign: TextAlign.left,
//                             style: AppTextStyles.inputLabel,
//                           ),
//                           AppSpacing.vsm,
//                           AppTextField(
//                             controller: passwordController,
//                             hintText: 'Enter your password',
//                             isPassword: true,
//                             prefixIcon: Icon(
//                               Icons.lock_outline,
//                               color: AppColors.primaryYellow,
//                               size: 20.sp,
//                             ),
//                             textInputAction: TextInputAction.done,
//                             validator: Validators.password,
//                             //onFieldSubmitted: (value) => vm.login(),
//                           ),
//                           AppSpacing.vsm,
//                           Text(
//                             "username",
//                             textAlign: TextAlign.left,
//                             style: AppTextStyles.inputLabel,
//                           ),
//                           AppSpacing.vsm,
//                           AppTextField(
//                             controller: usernameController,
//                             hintText: 'username',
//                             //isPassword: true,
//                             prefixIcon: Icon(
//                               Icons.lock_outline,
//                               color: AppColors.primaryYellow,
//                               size: 20.sp,
//                             ),
//                             textInputAction: TextInputAction.done,
//                             validator: (value) =>
//                                 Validators.username(usernameController.text),
//                             //onFieldSubmitted: (value) => vm.login(),
//                           ),
//                           AppSpacing.vxl,
//                           Padding(
//                             padding: AppSpacing.screenPadding,
//                             child: Text(
//                               "By signing up, you agree to our Terms and PrivacyPolicy.",
//                               style: AppTextStyles.legalText,
//                             ),
//                           ),
//                           AppSpacing.vsm,
//                           AppButton(
//                             // text: state.isLoading ? 'Creating account...' : 'Sign Up',
//                             isGhost: false,
//                             width: double.infinity,
//                             text: 'SignUp',
//                             onPressed: () {
//                               ref
//                                   .read(authProvider.notifier)
//                                   .signup(
//                                     fullnameController.text,
//                                     emailController.text,
//                                     passwordController.text,
//                                     //context,
//                                   );

//                               final name = fullnameController.text.trim();
//                               final email = emailController.text.trim();
//                               final username = usernameController.text.trim();

//                               // 1. Brain ko data hand-over karein
//                               ref
//                                   .read(authProvider.notifier)
//                                   .saveData(
//                                     name: name,
//                                     email: email,
//                                     username: username,
//                                   );

//                               // 2. Controllers ko clear kar dein jaisa aap chahti thin
//                               fullnameController.clear();
//                               emailController.clear();
//                               usernameController.clear();

//                               //ref.read(authProvider.notifier).
//                               //saveData();

//                               // signup(name: fullnameController.text,
//                               // email: emailController.text,
//                               //  password: passwordController.text,
//                               //   username: usernameController.text,
//                               //    context: context);
//                               // signup(
//                               // fullnameController.text,
//                               // emailController.text,
//                               // passwordController.text,
//                               // usernameController.text,
//                               //context, name: '', email: '', password: '', username: '', context: null);

//                               //saveData();
//                             },
//                           ),
//                           AppSpacing.vsm,
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Don't have an account?",
//                                 style: AppTextStyles.authSubtitle,
//                               ),
//                               AppTextButton(
//                                 text: "Login",
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => LoginScreen(),
//                                     ),
//                                   );
//                                 },
//                                 textStyle: AppTextStyles.textLink.copyWith(
//                                   color: AppColors.primaryYellow,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


//--------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/presentation/components/splash/splash_logo.dart';
import 'package:wink_app/presentation/screens/auth/login_screen.dart';
<<<<<<< HEAD
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
=======
import 'package:wink_app/presentation/screens/home/home_screen.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/text_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
<<<<<<< HEAD
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
=======

    final authState = ref.watch(authProvider);
    final authVM = ref.read(authProvider.notifier);

    /// :white_check_mark: Listen for success (user logged in / signed up)
    ref.listen(authProvider, (previous, next) {
      if (next.user != null && previous?.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully :tada:"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }

      /// error toast
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

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

                                /// NAME
                                Text("Your Name",
                                    style: AppTextStyles.inputLabel),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: nameController,
                                  hintText: 'Enter your name',
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: Validators.name,
                                ),

                                AppSpacing.vsm,

                                /// EMAIL
                                Text("Email Address",
                                    style: AppTextStyles.inputLabel),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: emailController,
                                  hintText: 'Enter your email',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: Validators.email,
                                ),

                                AppSpacing.vsm,

                                /// PASSWORD
                                Text("Password",
                                    style: AppTextStyles.inputLabel),
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
                                  validator: Validators.password,
                                ),

                                AppSpacing.vsm,

                                /// CONFIRM PASSWORD
                                Text("Confirm Password",
                                    style: AppTextStyles.inputLabel),
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
                                  validator: (value) =>
                                      Validators.confirmPassword(
                                          value, passwordController.text),
                                ),

                                AppSpacing.vsm,

                                /// BUTTON
                                AppButton(
                                  width: double.infinity,
                                  text: authState.loading
                                      ? "Creating account..."
                                      : "Sign Up",
                                  isGhost: false,
                                  onPressed: authState.loading
                                      ? null
                                      : () {
                                          if (!formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          authVM.signup(
                                            nameController.text.trim(),
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                          );
                                        },
                                ),

                                AppSpacing.vsm,

                                /// LOGIN NAV
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: AppTextStyles.authSubtitle,
                                    ),
                                    AppTextButton(
                                      text: "Login",
                                      textStyle:
                                          AppTextStyles.textLink.copyWith(
                                        color: AppColors.primaryYellow,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
<<<<<<< HEAD
            ),
         
=======
            );
          },
        ),
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
      ),
    );
  }
}