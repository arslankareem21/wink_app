
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/presentation/screens/home/home.dart';
import 'package:wink_app/presentation/widgets/bottom_navbar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/text_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryYellow),
          onPressed: () {
            Navigator.pop(context);
          }
      ),
      ),
      body: SafeArea(
        child: Center(
          child: Card(
            margin: AppSpacing.cardPadding,
            elevation: 4,
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.vxxl,
                  Text(
                    textAlign: TextAlign.left,
                  "Reset Password",
                    style: AppTextStyles.authHeadline,
                    ),
                AppSpacing.vsm,
                 Text(
                  "Please enter your email to reset your password",
                               style: AppTextStyles.authSubtitle,
                               ),
                        AppSpacing.vsm,
                  AppTextField(
                  // controller:emailController,
                  hintText: 'Enter your email',
                 prefixIcon: Icon(
               Icons.email_outlined,
                 color: AppColors.primaryYellow,
                 size: 20.sp,
                ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                        
                  ),
                   AppSpacing.vxxxl,
                  AppButton(text: "Send Reset Link", onPressed: () {
                    
                  }),
                    AppSpacing.vxxl,

                    Center(
                      child: AppTextButton(
                        text: "Send Reset Link", 
                      textStyle: AppTextStyles.screenTitle.copyWith(
                        color: AppColors.primaryYellow,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavScreen()));
                                        }),
                    ),
                ],
              ),
            ),
      ),
        ),
      ),
    );
  }
}