import 'dart:async';
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

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  Timer? _emailDebounce;
  Timer? _passwordDebounce;
  Timer? _confirmPasswordDebounce;

  bool _acceptedTerms = false;

  @override
  void dispose() {
    _emailDebounce?.cancel();
    _passwordDebounce?.cancel();
    _confirmPasswordDebounce?.cancel();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  String _capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (prev, next) {
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
                                  focusNode: nameFocus,
                                  hintText: 'Enter your name',
                                  textCapitalization: TextCapitalization.words,
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: (v) => Validators.name(nameController.text),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                                  ],
                                  onChanged: (value) {
                                    final capitalized = _capitalizeWords(value);
                                    if (capitalized != value) {
                                      final cursorPos = nameController.selection.baseOffset +
                                          (capitalized.length - value.length);
                                      nameController.value = nameController.value.copyWith(
                                        text: capitalized,
                                        selection: TextSelection.collapsed(
                                          offset: cursorPos.clamp(0, capitalized.length),
                                        ),
                                      );
                                    }
                                  },
                                  onFieldSubmitted: (_) => emailFocus.requestFocus(),
                                ),
                                AppSpacing.vsm,
                                Text(
                                  "Email Address",
                                  style: AppTextStyles.inputLabel,
                                ),
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
                                  onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                                ),
                                AppSpacing.vsm,
                                Text(
                                  "Password",
                                  style: AppTextStyles.inputLabel,
                                ),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: passwordController,
                                  focusNode: passwordFocus,
                                  hintText: 'Enter your password',
                                  textInputAction: TextInputAction.next,
                                  isPassword: true,
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: (v) => Validators.password(passwordController.text),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  onChanged: (value) {
                                    _passwordDebounce?.cancel();
                                    _passwordDebounce = Timer(
                                      const Duration(milliseconds: 500),
                                      () {
                                        final noSpaces = value.replaceAll(RegExp(r'\s'), '');
                                        if (noSpaces != value) {
                                          final cursorPos = passwordController.selection.baseOffset -
                                              (value.length - noSpaces.length);
                                          passwordController.value = passwordController.value.copyWith(
                                            text: noSpaces,
                                            selection: TextSelection.collapsed(
                                              offset: cursorPos.clamp(0, noSpaces.length),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  onFieldSubmitted: (_) => confirmPasswordFocus.requestFocus(),
                                ),
                                AppSpacing.vsm,
                                Text(
                                  "Confirm Password",
                                  style: AppTextStyles.inputLabel,
                                ),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: confirmPasswordController,
                                  focusNode: confirmPasswordFocus,
                                  textInputAction: TextInputAction.done,
                                  hintText: 'Confirm your password',
                                  isPassword: true,
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: AppColors.primaryYellow,
                                    size: 20.sp,
                                  ),
                                  validator: (v) => Validators.confirmPassword(
                                    confirmPasswordController.text,
                                    passwordController.text,
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  onChanged: (value) {
                                    _confirmPasswordDebounce?.cancel();
                                    _confirmPasswordDebounce = Timer(
                                      const Duration(milliseconds: 500),
                                      () {
                                        final noSpaces = value.replaceAll(RegExp(r'\s'), '');
                                        if (noSpaces != value) {
                                          final cursorPos = confirmPasswordController.selection.baseOffset -
                                              (value.length - noSpaces.length);
                                          confirmPasswordController.value = confirmPasswordController.value.copyWith(
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
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _acceptedTerms,
                                      activeColor: AppColors.primaryYellow,
                                      onChanged: (val) {
                                        setState(() => _acceptedTerms = val ?? false);
                                      },
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                                        child: RichText(
                                          text: TextSpan(
                                            style: AppTextStyles.authSubtitle.copyWith(fontSize: 12.sp),
                                            children: [
                                              const TextSpan(text: 'I agree to the '),
                                              TextSpan(
                                                text: 'Terms & Conditions',
                                                style: AppTextStyles.textLink.copyWith(
                                                  fontSize: 12.sp,
                                                  color: AppColors.primaryYellow,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
                                  onPressed: (isLoading || !_acceptedTerms)
                                      ? null
                                      : () {
                                          if (!formKey.currentState!.validate()) return;
                                          ref
                                              .read(
                                                authViewModelProvider.notifier,
                                              )
                                              .signup(
                                                emailController.text.trim(),
                                                passwordController.text.trim(),
                                                nameController.text.trim(),
                                              );
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