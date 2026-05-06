import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/models/auth/login_model.dart';
import 'package:wink_app/presentation/provider/auth/auth_provider.dart';


class LoginViewModelState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const LoginViewModelState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  LoginViewModelState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return LoginViewModelState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginViewModelState> {
  LoginViewModel(this.ref) : super(const LoginViewModelState());

  final Ref ref;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
      print('1. Login started');

    if (!formKey.currentState!.validate()) return;

    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    print('2. Set loading true');
    try {
      print('3. Calling Firebase');
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final user = await ref.read(authServiceProvider).login(request);
      print('4. Firebase success: ${user.email}');
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Logged in as ${user.email}',
      );
      print('5. Set loading false');

    } catch (e) {
      print('ERROR: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginViewModelState>(
  (ref) => LoginViewModel(ref),
);