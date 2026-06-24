import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/service/auth_service.dart'; // to access repo

class EditProfileState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const EditProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  EditProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class EditProfileViewModel extends Notifier<EditProfileState> {
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepo; // ADD THIS

  EditProfileViewModel(this._firestore, this._authRepo); // UPDATE

  @override
  EditProfileState build() {
    return const EditProfileState();
  }

  Future<void> updateProfileData({
    required String uid,
    required String displayName,
    required String username,
    required String bio,
    required String website,
    required String category,
    required String collaborationEmail,
    required String location,
  }) async {
    if (!ref.mounted || uid.isEmpty) {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid user ID',
          isSuccess: false,
        );
      }
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      // ADD THIS: Check username availability before updating
      final cleanUsername = username.trim().toLowerCase();
      final isAvailable = await _authRepo.isUsernameAvailable(
        cleanUsername,
        excludeUid: uid,
      );
      
      if (!isAvailable) {
        throw Exception('Username already taken');
      }

      final Map<String, dynamic> data = {
        'name': displayName,
        'username': cleanUsername,
        'bio': bio,
        'description': bio,
        'website': website,
        'category': category,
        'location': location,
        'collaborationEmail': collaborationEmail,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(uid).update(data);

      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
          isSuccess: true,
        );
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
          isSuccess: false,
        );
      }
      rethrow;
    }
  }

  void clearError() {
    if (ref.mounted) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void reset() {
    if (ref.mounted) {
      state = const EditProfileState();
    }
  }
}

final editProfileViewModelProvider =
    NotifierProvider.autoDispose<EditProfileViewModel, EditProfileState>(() {
  final authRepo = AuthRepository(); // or ref.read(authRepositoryProvider)
  return EditProfileViewModel(FirebaseFirestore.instance, authRepo);
});