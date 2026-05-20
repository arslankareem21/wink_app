import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wink_app/service/signup_auth_service.dart';

final sigUpAuthViewModelProvider = AsyncNotifierProvider<SignUpAuthViewModel, void>(() {
      return SignUpAuthViewModel();
    });

class SignUpAuthViewModel extends AsyncNotifier<void> {
  late final AuthService _authService;

  @override
  Future<void> build() async {
    _authService = ref.read(authServiceProvider);
  }



  Future<void> executeFirebaseSignUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required Function() onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    // Turn on the visual loading spinner indicator state
    state = const AsyncLoading();

    // Guard the async transaction from throwing runtime system application crashes
    state = await AsyncValue.guard(() async {
      await _authService.firebaseSignUp(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
      );
    });

    // Handle reporting back the UI execution result safely
    if (state.hasError) {
      // Strips away instance headers to isolate the plain readable string error message
      onError(state.error.toString().replaceAll('Exception: ', ''));
    } else {
      onSuccess();
    }
  }
}









// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth exceptions handle karne ke liye
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:wink_app/service/login_auth_service.dart';
// import 'package:wink_app/service/signup_auth_service.dart';

// // 1. Provider configuration jo UI se connect hogi
// final sigUpAuthViewModelProvider = AsyncNotifierProvider<SignUpAuthViewModel, void>(() {
//   return SignUpAuthViewModel();
// });

// class SignUpAuthViewModel extends AsyncNotifier<void> {
//   late final AuthService _authService;

//   @override
//   Future<void> build() async {
//     // FIX 1: 'ref.read' ki jagah 'ref.watch' use karein, yeh Riverpod ka rule hai build ke andar
//     _authService = ref.watch(authServiceProvider);
//   }

//   Future<void> executeFirebaseSignUp({
//     required String email,
//     required String password,
//     required String username,
//     required String fullName,
//     required Function() onSuccess,
//     required Function(String errorMessage) onError,
//   }) async {
//     // 1. UI ko loading state par bhej diya (Spinner ghoomne lagega)
//     state = const AsyncLoading();

//     // 2. Service ko call kiya aur safe guard lagaya taaki app crash na ho
//     state = await AsyncValue.guard(() async {
//       await _authService.firebaseSignUp(
//         email: email,
//         password: password,
//         username: username,
//         fullName: fullName,
//       );
//     });

//     // 3. UI ko result wapas bhejna
//     if (state.hasError) {
//       final error = state.error;
//       String userFriendlyMessage = "An unknown error occurred.";

//       // FIX 2: Agar error Firebase ki taraf se hai, toh sirf aasan English wala message nikalna
//       if (error is FirebaseAuthException) {
//         userFriendlyMessage = error.message ?? userFriendlyMessage;
//       } else {
//         userFriendlyMessage = error.toString().replaceAll('Exception: ', '');
//       }

//       onError(userFriendlyMessage); // UI ko error bhej diya
//     } else {
//       onSuccess(); // UI ko success bhej diya
//     }
//   }
//}