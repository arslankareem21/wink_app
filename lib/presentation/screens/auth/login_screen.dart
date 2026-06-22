import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/presentation/components/splash/splash_logo.dart';
import 'package:wink_app/presentation/screens/auth/setup_dailog.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/text_button.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final passwordFocus = useFocusNode();

    final authState = ref.watch(authViewModelProvider);
    final isEmailLoading = authState.loadingType == AuthLoadingType.emailLogin;
    final isGoogleLoading = authState.loadingType == AuthLoadingType.googleSignIn;

    useEffect(() {
      void listener() {
        final state = ref.read(authViewModelProvider);

        // Autofill email
        if (state.autofillEmail != null &&
            state.autofillEmail != emailController.text) {
          emailController.text = state.autofillEmail!;
          passwordController.clear();
          passwordFocus.requestFocus();
        }

        // Show password setup dialog
        if (state.showPasswordDialog) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const SetupPasswordDialog(),
          );
        }

        // Fixed: Navigate on 'Login successful' instead of goToHome
        if (state.message == 'Login successful' ||
            state.message == 'Password set successfully') {
          NavigationService.go(context, AppRoutes.home);
          ref.read(authViewModelProvider.notifier).clear();
        }

        // Error dialog for account-exists
        if (state.error?.contains('Please login with Email & Password') == true) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Account Found'),
              content: Text(state.error!),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(authViewModelProvider.notifier).clear();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(authViewModelProvider.notifier).clear();
                    passwordFocus.requestFocus();
                  },
                  child: const Text('Enter Password'),
                ),
              ],
            ),
          );
        } else if (state.error != null) {
          AppSnackBar.show(state.error!, isError: true);
          ref.read(authViewModelProvider.notifier).clear();
        }

        if (state.message != null &&
            !state.message!.contains('successful')) {
          AppSnackBar.show(state.message!);
          ref.read(authViewModelProvider.notifier).clear();
        }
      }

      final sub = ref.listenManual(authViewModelProvider, (_, _) => listener());
      return sub.close;
    }, []);

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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppSpacing.vxl,
                                const Center(child: SplashLogo()),
                                AppSpacing.vsm,
                                Center(
                                  child: Text("Welcome Back!",
                                      style: AppTextStyles.authHeadline),
                                ),
                                AppSpacing.vsm,
                                Center(
                                  child: Text("Please login to your account",
                                      style: AppTextStyles.authSubtitle),
                                ),
                                AppSpacing.vsm,
                                Text("Email Address",
                                    style: AppTextStyles.inputLabel),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: emailController,
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(Icons.email_outlined,
                                      color: AppColors.primaryYellow,
                                      size: 20.sp),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.email,
                                ),
                                AppSpacing.vsm,
                                Text("Password",
                                    style: AppTextStyles.inputLabel),
                                AppSpacing.vsm,
                                AppTextField(
                                  controller: passwordController,
                                  focusNode: passwordFocus,
                                  hintText: 'Enter your password',
                                  isPassword: true,
                                  prefixIcon: Icon(Icons.lock_outline,
                                      color: AppColors.primaryYellow,
                                      size: 20.sp),
                                ),
                                AppSpacing.vsm,
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: AppTextButton(
                                    text: "Forgot Password?",
                                    textStyle: AppTextStyles.textLink,
                                    onPressed: () => NavigationService.push(
                                        context, AppRoutes.forgotPassword),
                                  ),
                                ),
                                AppSpacing.vsm,
                                AppButton(
                                  text: isEmailLoading
                                      ? "Logging in..."
                                      : "Login",
                                  isGhost: false,
                                  width: double.infinity,
                                  onPressed: isEmailLoading || isGoogleLoading
                                      ? null
                                      : () {
                                    if (formKey.currentState!
                                        .validate()) {
                                      ref
                                          .read(authViewModelProvider
                                          .notifier)
                                          .login(
                                        emailController.text.trim(),
                                        passwordController.text
                                            .trim(),
                                      );
                                    }
                                  },
                                ),
                                AppSpacing.vsm,
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Text("or continue with",
                                          style: AppTextStyles.authSubtitle),
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                AppSpacing.vsm,
                                Center(
                                  child: AppButton(
                                    width: 240.w,
                                    text: isGoogleLoading
                                        ? "Signing in..."
                                        : "Continue with Google",
                                    isGhost: true,
                                    icon: SvgPicture.asset(
                                        'assets/icon/google.svg'),
                                    onPressed: isGoogleLoading || isEmailLoading
                                        ? null
                                        : () => ref
                                        .read(authViewModelProvider
                                        .notifier)
                                        .signInWithGoogle(),
                                  ),
                                ),
                                AppSpacing.vsm,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account?",
                                        style: AppTextStyles.authSubtitle),
                                    AppTextButton(
                                      text: "Sign Up",
                                      textStyle:
                                      AppTextStyles.textLink.copyWith(
                                          color: AppColors.primaryYellow),
                                      onPressed: () => 
                                      NavigationService.push(
                                          context, AppRoutes.signup),
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