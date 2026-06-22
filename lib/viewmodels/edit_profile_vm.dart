import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      isLoading: isLoading?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess?? this.isSuccess,
    );
  }
}

class EditProfileViewModel extends Notifier<EditProfileState> {
  final FirebaseFirestore _firestore;

  EditProfileViewModel(this._firestore);

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

    try {
      state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

      final Map<String, dynamic> data = {
        'name': displayName,
        'username': username,
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
  return EditProfileViewModel(FirebaseFirestore.instance);
});