import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _emailDebounce;
  final emailFocus = FocusNode();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (prev, next) {
      if (next.message != null && next.message != prev?.message) {
        AppSnackBar.show(next.message!);
        context.pop(); // Go back to login after success
      }
      if (next.error != null && next.error != prev?.error) {
        AppSnackBar.show(next.error!, isError: true);
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.loadingType == AuthLoadingType.resetRequest;
    final emailDebounce = useRef<Timer?>(null);
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
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppSpacing.vxl,
                                const Center(child: SplashLogo()),
                                AppSpacing.vsm,
                                Center(
                                  child: Text("Reset Password",
                                      style: AppTextStyles.authHeadline),
                                ),
                                AppSpacing.vsm,
                                Center(
                                  child: Text(
                                      "Enter your email to receive a reset link",
                                      style: AppTextStyles.authSubtitle,
                                      textAlign: TextAlign.center),
                                ),
                                AppSpacing.vsm,
                                Text("Email Address", style: AppTextStyles.inputLabel),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: emailController,
                                  focusNode: emailFocus,
                                  hintText: 'Enter your email',
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.none,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) => Validators.email(emailController.text),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  onChanged: (value) {
                                    _emailDebounce?.cancel();
                                    _emailDebounce = Timer(
                                      const Duration(milliseconds: 500),
                                      () {
                                        final noSpaces = value.replaceAll(RegExp(r'\s'), '');
                                        if (noSpaces != value) {
                                          final cursorPos = emailController.selection.baseOffset -
                                              (value.length - noSpaces.length);
                                          emailController.value = emailController.value.copyWith(
                                            text: noSpaces,
                                            selection: TextSelection.collapsed(
                                              offset: cursorPos.clamp(0, noSpaces.length),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  
                                ),
                                AppSpacing.vsm,
                                AppButton(
                                  text: isLoading ? "Sending..." : "Send Reset Link",
                                  isGhost: false,
                                  width: double.infinity,
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!.validate()) {
                                            ref
                                                .read(authViewModelProvider.notifier)
                                                .sendResetLink(
                                                    emailController.text.trim());
                                          }
                                        },
                                ),
                                AppSpacing.vsm,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Remember password?",
                                        style: AppTextStyles.authSubtitle),
                                    AppTextButton(
                                      text: "Login",
                                      textStyle: AppTextStyles.textLink
                                          .copyWith(color: AppColors.primaryYellow),
                                      onPressed: () => context.pop(),
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