import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/models/auth/user_model.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/service/auth_service.dart';

enum AuthLoadingType {
  none,
  emailLogin,
  emailSignup,
  googleSignIn,
  resetRequest,
  setPassword,
  passwordSetup,
}

class AuthState {
  final AuthLoadingType loadingType;
  final String? error;
  final String? message;
  final String? autofillEmail;
  final bool showPasswordDialog;

  const AuthState({
    this.loadingType = AuthLoadingType.none,
    this.error,
    this.message,
    this.autofillEmail,
    this.showPasswordDialog = false,
  });

  bool get isLoading => loadingType != AuthLoadingType.none;

  AuthState copyWith({
    AuthLoadingType? loadingType,
    String? error,
    String? message,
    String? autofillEmail,
    bool? showPasswordDialog,
  }) {
    return AuthState(
      loadingType: loadingType ?? this.loadingType,
      error: error,
      message: message,
      autofillEmail: autofillEmail,
      showPasswordDialog: showPasswordDialog ?? this.showPasswordDialog,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  AuthViewModel(this._repo) : super(const AuthState());

  // Bug 10: Signup + auto logout
  Future<void> signup(String email, String password, String name) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.emailSignup,
      error: null,
      message: null,
     // autofillEmail: null,
    );
    try {
      await _repo.signUp(email, password, name);
      await _repo.signOut(); // Bug 10: Force login after signup
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: "Account created. Please login",
      );
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.emailLogin,
      error: null,
      message: null,
    );
    try {
      await _repo.signIn(email, password);
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: 'Login successful',
        
      );
      AppSnackBar.show('login successful');
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  
  Future<void> signInWithGoogle() async {
    state = state.copyWith(
      loadingType: AuthLoadingType.googleSignIn,
      error: null,
      message: null,
      autofillEmail: null,
      showPasswordDialog: false, 
    );
    try {
      final result = await _repo.signInWithGoogle();

      if (result == null) {
        state = const AuthState();
        return;
      }

      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: 'Login successful',
      );
    } catch (e) {
      final msg = _cleanError(e);
      
      String? email;
      if (msg.contains('Please login with Email & Password')) {
        email = _repo.currentUser?.email;
      }
      
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: msg,
        autofillEmail: email,
      );
    }
  }
Future<void> setupGoogleUserPassword(String newPassword) async {
  state = state.copyWith(
    loadingType: AuthLoadingType.passwordSetup, 
    error: null,
    message: null,
  );

  try {
    final needsPassword = await _repo.needsPasswordSetup();
    
    if (needsPassword) {
      await _repo.updatePassword(newPassword); 
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: 'Password successfully set for your account!', 
      );
    } else {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: 'Password is already set for this account.',
      );
    }
  } catch (e) {
    state = state.copyWith(
      loadingType: AuthLoadingType.none,
      error: _cleanError(e),
    );
  }
}
 Future<void> cancelPasswordSetup() async {
    state = state.copyWith(
      loadingType: AuthLoadingType.none,
      showPasswordDialog: false,
      error: null,
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState(message: 'Signed out');
  }

  Future<void> sendResetLink(String email) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.resetRequest,
      error: null,
      message: null,
      autofillEmail: null,
    );
    try {
      await _repo.sendResetLink(email);
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: "Reset link sent to your email",
      );
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null, message: null, autofillEmail: null);
  }

  void clear() => state = const AuthState();

  String _cleanError(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthViewModel(repo);
});


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUser?.uid;
});


final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.exists ? UserModel.fromDoc(doc) : null);
});

final usernameAvailableProvider = FutureProvider.autoDispose.family<bool, ({String username, String uid})>((ref, params) async {
  if (params.username.trim().isEmpty) return true;
  final repo = ref.read(authRepositoryProvider);
  return await repo.isUsernameAvailable(params.username, excludeUid: params.uid);
});