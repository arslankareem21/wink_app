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
