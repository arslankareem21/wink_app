// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:wink_app/service/auth_sevice.dart';

// class AuthState {
//   final User? user;
//   final bool isLoading;
//   final String? error;

//   AuthState({
//     required this.user,
//     required this.isLoading,
//     required this.error,
//   });

//   factory AuthState.initial() =>
//       AuthState(user: null, isLoading: false, error: null);

//   AuthState copyWith({
//     User? user,
//     bool? isLoading,
//     String? error,
//   }) {
//     return AuthState(
//       user: user ?? this.user,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }
// }

// final authViewModelProvider =
//     NotifierProvider<AuthViewModel, AuthState>(AuthViewModel.new);




// class AuthViewModel extends Notifier<AuthState> {
//   final AuthService _service = AuthService();

//   @override
//   AuthState build() {
//     return AuthState.initial();
//   }

//   /// 👇 THIS is what button calls
//   Future<void> signInWithGoogle() async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final user = await _service.signInWithGoogle();

//       state = state.copyWith(
//         user: user,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   Future<void> signOut() async {
//     await _service.signOut();
//     state = state.copyWith(user: null);
//   }
// }