<<<<<<< HEAD
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
=======
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wink_app/models/auth/login_signup_model.dart';
// // Note: Verify if your file is named auth_sevice.dart or auth_service.dart
// import 'package:wink_app/service/auth_sevice.dart'; 
// import 'package:wink_app/presentation/screens/auth/login_screen.dart';
// import 'package:wink_app/presentation/screens/home/home_screen.dart';
// import '../models/user_model.dart';

// class AuthViewModel extends AsyncNotifier<UserModel?> {
//   final _authService = AuthService();

//   @override
//   Future<UserModel?> build() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       return UserModel(
//         id: user.uid,
//         name: user.displayName ?? '',
//         email: user.email ?? '',
//         username: user.email?.split('@')[0] ?? '',
//       );
//     }
//     return null;
//   }

//   String _translateAuthError(String code) {
//     switch (code) {
//       case 'user-not-found': return 'No user found with this email.';
//       case 'wrong-password': return 'Incorrect password.';
//       case 'email-already-in-use': return 'This email is already registered.';
//       case 'weak-password': return 'The password provided is too weak.';
//       case 'invalid-email': return 'The email address is badly formatted.';
//       case 'network-request-failed': return 'Network error. Please check your connection.';
//       default: return 'Authentication failed. Please try again.';
//     }
//   }

//   Future<void> login(String email, String password, BuildContext context) async {
//     state = const AsyncValue.loading();
//     try {
//       final user = await _authService.login(email, password);
//       state = AsyncValue.data(user);
//       if (user != null && context.mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//         );
//       }
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   Future<void> signup(String name, String email, String password, BuildContext context) async {
//     state = const AsyncValue.loading();
//     try {
//       final user = await _authService.signup(email, password);
//       state = AsyncValue.data(user);
//       if (user != null && context.mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) =>  LoginScreen()),
//         );
//       }
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   Future<void> saveData({
//     required String name,
//     required String email,
//     required String username,
//   }) async {
//     if (name.isEmpty || email.isEmpty || username.isEmpty) {
//       state = AsyncValue.error('Please fill all fields', StackTrace.current);
//       return;
//     }

//     state = const AsyncValue.loading();
//     try {
//       await _authService.saveUserDataToFirestore(
//         name: name,
//         email: email,
//         username: username,
//       );
      
//       // Update local state with new user data after successful save
//       final currentUser = state.value;
//       if (currentUser != null) {
//         state = AsyncValue.data(UserModel(
//           id: currentUser.id,
//           name: name,
//           email: email,
//           username: username,
//         ));
//       } else {
//         state = const AsyncValue.data(null);
//       }
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   // 🔹 Google Sign-In ✅ FIXED
//   Future<void> signInWithGoogle(BuildContext context) async {
//     state = const AsyncValue.loading();
//     try {
//       // 1. Get Firebase User from Service
//       final firebaseUser = await _authService.signInWithGoogle();

//       if (firebaseUser != null) {
//         // 2. Convert Firebase User to your App's UserModel
//         final userModel = UserModel(
//           id: firebaseUser.uid,
//           name: firebaseUser.displayName ?? 'User',
//           email: firebaseUser.email ?? '',
//           username: firebaseUser.email?.split('@')[0] ?? 'user',
//         );

//         state = AsyncValue.data(userModel);

//         // 3. Safe Navigation
//         if (context.mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const HomeScreen()),
//           );
//         }
//       } else {
//         // User cancelled the Google Sign-In prompt silently
//         state = const AsyncValue.data(null);
//       }
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   // 🔹 Sign Out ✅ FIXED
//   Future<void> signOut(BuildContext context) async {
//     state = const AsyncValue.loading();
//     try {
//       await _authService.signOut();
//       state = const AsyncValue.data(null);

//       // Safe Navigation back to Login
//       if (context.mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) =>  LoginScreen()),
//           (route) => false, // Clears the entire navigation stack
//         );
//       }
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }
// }

// // 🔹 Riverpod Provider Declaration
// final authProvider = AsyncNotifierProvider<AuthViewModel, UserModel?>(
//   AuthViewModel.new,
// );








//---------------------------------------------

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:wink_app/models/auth/login_signup_model.dart';
import 'package:wink_app/service/auth_sevice.dart';


class AuthState {
  final UserModel? user;
  final bool loading;
  final String? error;

  const AuthState({
    this.user,
    this.loading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? loading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  bool get isAuth => user != null;
}

class AuthViewModel extends Notifier<AuthState> {
  final _service = AuthService();

  @override
  AuthState build() {
    _restoreSession();
    return const AuthState();
  }

  /// Restore saved login session
  Future<void> _restoreSession() async {
    try {
      final user = await _service.getCurrentUser();

      if (user != null) {
        state = state.copyWith(user: user);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// EMAIL SIGNUP
  Future<void> signup(String name, String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final user = await _service.signup(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: user,
        loading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// EMAIL LOGIN
  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final user = await _service.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: user,
        loading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// GOOGLE LOGIN
  Future<void> googleLogin() async {
    state = state.copyWith(loading: true, error: null);

    try {
      final user = await _service.signInWithGoogle();

      state = state.copyWith(
        user: user,
        loading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _service.signOut();
    state = const AuthState();
  }

  /// RESET PASSWORD
  Future<void> resetPassword(String email) async {
    try {
      await _service.resetPassword(email);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// CLEAR ERROR
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider
final authProvider =
    NotifierProvider<AuthViewModel, AuthState>(() => AuthViewModel());
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
