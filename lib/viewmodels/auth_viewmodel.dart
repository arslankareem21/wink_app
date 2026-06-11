import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/service/auth_service.dart';

enum AuthLoadingType {
  none,
  emailLogin,
  emailSignup,
  googleSignIn,
  resetRequest,
  setPassword,
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
      autofillEmail: null,
    );
    try {
      await _repo.signUp(email, password, name);
      await _repo.signOut(); // Bug 10: Force login after signup
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: "Account created. Please login",
        autofillEmail: email,
      );
    } catch (e) {
      // Bug 27, 28, 29: Always reset loading on error
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  // Bug 8: Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.emailLogin,
      error: null,
      message: null,
      autofillEmail: null,
    );
    try {
      await _repo.signIn(email, password);
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: 'Login successful',
      );
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  // Bug 6, 7, 22, 27: Google Sign In + Stuck Button Fix
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
      
      // Bug 22: User cancelled picker
      if (result == null) {
        state = const AuthState(); // Reset completely
        return;
      }

      // Bug 3, 4, 5: Check password setup
      final needsPassword = await _repo.needsPasswordSetup();
      if (needsPassword) {
        state = state.copyWith(
          loadingType: AuthLoadingType.none,
          showPasswordDialog: true,
        );
        return;
      }

      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: 'Login successful',
      );
    } catch (e) {
      final msg = _cleanError(e);
      // Bug 6, 7: Extract email for UX
      String? email;
      if (msg.contains('Please login with Email & Password')) {
        email = _repo.currentUser?.email;
      }
      // Critical: Always reset loadingType on error - Fixes stuck button
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: msg,
        autofillEmail: email,
      );
    }
  }

  // Bug 15, 20, 22, 25, 26, 29: Set password for Google user
  Future<void> setPasswordForGoogleUser(String password) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.setPassword,
      error: null,
      autofillEmail: null,
    );
    try {
      await _repo.setPasswordForGoogleUser(password);
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        showPasswordDialog: false,
        message: 'Password set successfully',
      );
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  // Bug 20: Cancel password setup = logout
  Future<void> cancelPasswordSetup() async {
    await _repo.signOut();
    state = const AuthState(
      showPasswordDialog: false,
      message: 'Password setup required to continue',
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState(message: 'Signed out');
  }

  // Bug 15: Password reset
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
  // Watches the repository instance and returns the UID if a user is logged in
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUser?.uid;
});