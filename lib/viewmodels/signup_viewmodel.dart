




















// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:wink_app/service/signup_auth_service.dart'; // Apni service ka sahi path dein

// // 1. Service Provider Configuration
// // Agar aapne pehle se nahi banaya, toh service ko access karne ke liye yeh provider chahiye
// final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
//   return FirebaseAuthService();
// });

// // 2. ViewModel Provider Configuration (UI isko read/watch karegi)
// final signUpViewModelProvider = AsyncNotifierProvider<SignUpViewModel, User?>(() {
//   return SignUpViewModel();
// });

// // 3. ViewModel Class
// // Note: Hum yahan 'User?' return kar rahe hain kyunki aapki service signup ke baad 'User?' deti hai.
// class SignUpViewModel extends AsyncNotifier<User?> {
//   late final FirebaseAuthService _authService;

//   @override
//   FutureOr<User?> build() async {
//     // Service ka instance read/watch karna
//     _authService = ref.watch(firebaseAuthServiceProvider);
//     return _authService.currentUser; // Initial state user ka current status hogi
//   }

//   /// UI se data lekar signup process chalane wala function
//   Future<void> executeSignUp({
//     required String email,
//     required String password,
//     required String name,
//     required Function(User user) onSuccess,
//     required Function(String errorMessage) onError,
//   }) async {
//     // 1. UI par loading spinner show karne ke liye state badli
//     state = const AsyncLoading();

//     // 2. Service ko call kiya aur AsyncValue.guard se crash-safe banaya
//     state = await AsyncValue.guard(() async {
//       final user = await _authService.signUpWithEmailAndPassword(email, password, name);
      
//       if (user == null) {
//         // Agar service ne bina crash kiye null return kiya (jo aapke catch block mein hai)
//         throw Exception('Sign up failed. Please check your credentials.');
//       }
      
//       return user;
//     });

//     // 3. Result ke mutabiq UI ko callbacks (Signals) bhejna
//     if (state.hasError) {
//       final error = state.error;
//       String userFriendlyMessage = "An unexpected error occurred.";

//       if (error is FirebaseAuthException) {
//         userFriendlyMessage = error.message ?? userFriendlyMessage;
//       } else {
//         // 'Exception: ' ka tag hatane ke liye
//         userFriendlyMessage = error.toString().replaceAll('Exception: ', '');
//       }

//       onError(userFriendlyMessage); // UI ko error message bhej diya
//     } else {
//       // Agar state mein error nahi hai, toh data mein 'User' mil chuka hai
//       final registeredUser = state.value;
//       if (registeredUser != null) {
//         onSuccess(registeredUser); // UI ko success data bhej diya
//       }
//     }
//   }
// }







// //import 'package:flutter_riverpod/flutter_riverpod.dart';

// // 🔹 Auth State Class (UI ko dikhane ke liye)
// class AuthState {
//   final bool isLoading;
//   final User? user;
//   final String? errorMessage;
//   final bool isAuthenticated;

//   AuthState({
//     this.isLoading = false,
//     this.user,
//     this.errorMessage,
//     this.isAuthenticated = false,
//   });

//   AuthState copyWith({
//     bool? isLoading,
//     User? user,
//     String? errorMessage,
//     bool? isAuthenticated,
//   }) {
//     return AuthState(
//       isLoading: isLoading ?? this.isLoading,
//       user: user ?? this.user,
//       errorMessage: errorMessage ?? this.errorMessage,
//       isAuthenticated: isAuthenticated ?? this.isAuthenticated,
//     );
//   }
// }

// //https://gemini.google.com/app/9af93b1c02ebb253

// // 🔹 Auth ViewModel (AsyncNotifier)
// class AuthViewModel extends AsyncNotifier<AuthState> {
//   late final FirebaseAuthService _authService;

//   @override
//   Future<AuthState> build() async {
//     _authService = FirebaseAuthService();
    
//     // Initial state: Check if user already logged in
//     final currentUser = _authService.currentUser;
//     return AuthState(
//       user: currentUser,
//       isAuthenticated: currentUser != null,
//     );
//   }

//   // 🔹 Sign Up
//   Future<bool> signUp(String email, String password, String name) async {
//     state = const AsyncValue.loading();
    
//     try {
//       final user = await _authService.signUpWithEmailAndPassword(
//         email, password, name,
//       );
      
//       if (user != null) {
//         state = AsyncValue.data(
//           AuthState(
//             user: user,
//             isAuthenticated: true,
//             isLoading: false,
//           ),
//         );
//         return true;
//       }
//       state = AsyncValue.data(
//         AuthState(isLoading: false, errorMessage: 'Sign up failed'),
//       );
//       return false;
//     } catch (e) {
//       state = AsyncValue.data(
//         AuthState(
//           isLoading: false,
//           errorMessage: e.toString().replaceAll('Exception: ', ''),
//         ),
//       );
//       return false;
//     }
//   }

//   // 🔹 Sign In
//   Future<bool> signIn(String email, String password) async {
//     state = const AsyncValue.loading();
    
//     try {
//       final user = await _authService.signInWithEmailAndPassword(
//         email, password,
//       );
      
//       if (user != null) {
//         state = AsyncValue.data(
//           AuthState(
//             user: user,
//             isAuthenticated: true,
//             isLoading: false,
//           ),
//         );
//         return true;
//       }
//       state = AsyncValue.data(
//         AuthState(isLoading: false, errorMessage: 'Sign in failed'),
//       );
//       return false;
//     } catch (e) {
//       state = AsyncValue.data(
//         AuthState(
//           isLoading: false,
//           errorMessage: e.toString().replaceAll('Exception: ', ''),
//         ),
//       );
//       return false;
//     }
//   }
// }
 
//   // 🔹 Password Reset








