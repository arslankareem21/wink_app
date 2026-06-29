// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class EditProfileState {
//   final bool isLoading;
//   final String? errorMessage;

//   EditProfileState({
//     this.isLoading = false,
//     this.errorMessage,
//   });

//   EditProfileState copyWith({
//     bool? isLoading,
//     String? errorMessage,
//   }) {
//     return EditProfileState(
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage, 
//     );
//   }
// }

// class EditProfileViewModel extends Notifier<EditProfileState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   EditProfileState build() {
//     return EditProfileState();
//   }

//   Future<void> updateProfileData({
//     required String uid,
//     required String displayName,
//     required String username,
//     required String bio,
//     required String website,
//     String? category,
//     String? location,
//     String? collaborationEmail,
//   }) async {
//     state = state.copyWith(isLoading: true);

//     try {
//       await _firestore.collection('users').doc(uid).update({
//         'name': displayName,
//         'username': username,
//         'bio': bio,
//         'website': website,
//         if (category != null) 'category': category,
//         if (location != null) 'location': location,
//         if (collaborationEmail != null) 'collaborationEmail': collaborationEmail,
//         'updatedAt': FieldValue.serverTimestamp(), // Optional metadata track karne ke liye
//       });

//       state = state.copyWith(isLoading: false, errorMessage: null);
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: e.toString(),
//       );
//     }
//   }
// }

// final editProfileViewModelProvider =
//     NotifierProvider.autoDispose<EditProfileViewModel, EditProfileState>(() {
//   return EditProfileViewModel();
// });


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

// // 1. State class
// class EditProfileState {
//   final bool isLoading;
//   final String? errorMessage;
//   final bool isSuccess;

//   const EditProfileState({
//     this.isLoading = false,
//     this.errorMessage,
//     this.isSuccess = false,
//   });

//   EditProfileState copyWith({
//     bool? isLoading,
//     String? errorMessage,
//     bool? isSuccess,
//   }) {
//     return EditProfileState(
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage,
//       isSuccess: isSuccess ?? this.isSuccess,
//     );
//   }
// }

// // 2. ViewModel
// class EditProfileViewModel extends StateNotifier<EditProfileState> {
//   final FirebaseFirestore _firestore;

//   EditProfileViewModel(this._firestore) : super(const EditProfileState());

//   Future<void> updateProfileData({
//     required String uid,
//     required String displayName,
//     required String username,
//     required String bio,
//     required String website,
//     required String category,
//     required String collaborationEmail,
//     required String location,
//   }) async {
//     if (uid.isEmpty) {
//       state = state.copyWith(errorMessage: 'Invalid user ID');
//       return;
//     }

//     try {
//       state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

//       await _firestore.collection('users').doc(uid).update({
//         'name': displayName,
//         'username': username,
//         'bio': bio,
//         'description': bio, // You had both bio + description in your screen
//         'website': website,
//         'category': category,
//         'collaborationEmail': collaborationEmail,
//         'location': location,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       state = state.copyWith(isLoading: false, isSuccess: true);
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: e.toString().replaceAll('Exception: ', ''),
//         isSuccess: false,
//       );
//     }
//   }

//   void clearError() {
//     state = state.copyWith(errorMessage: null);
//   }

//   void reset() {
//     state = const EditProfileState();
//   }
// }

// // 3. Provider
// final editProfileViewModelProvider =
//     StateNotifierProvider<EditProfileViewModel, EditProfileState>((ref) {
//   return EditProfileViewModel(FirebaseFirestore.instance);
// });

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