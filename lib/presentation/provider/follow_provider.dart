import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/presentation/provider/follow_list_provider.dart';
import 'package:wink_app/presentation/provider/user_provider.dart'; 
import 'package:wink_app/service/profile_service/follow_service.dart';

final followServiceProvider = Provider((ref) => FollowService());

final followProvider =
    StateNotifierProvider.family<FollowNotifier, bool, FollowParams>(
  (ref, params) => FollowNotifier(ref, params),
);

class FollowParams {
  final String me;
  final String other;
  final Map<String, dynamic> myData;

  FollowParams(this.me, this.other, this.myData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowParams &&
          runtimeType == other.runtimeType &&
          me == other.me &&
          this.other == other.other;

  @override
  int get hashCode => Object.hash(me, other);
}



class FollowNotifier extends StateNotifier<bool> {
  final Ref ref;
  final FollowParams params;

  FollowNotifier(this.ref, this.params) : super(false) {
    check();
  }

  Future<void> check() async {
    state = await ref
        .read(followServiceProvider)
        .isFollowing(params.me, params.other);
  }

  Future<void> toggle() async {
    final service = ref.read(followServiceProvider);

    if (state) {
      await service.unfollow(
        me: params.me,
        other: params.other,
      );
      state = false;
    } else {
      await service.follow(
        me: params.me,
        other: params.other,
        myData: params.myData,
      );
      state = true;
    }

    //  MAIN FIX: User data ko invalidate karein taake followers/following counts update hon
    ref.invalidate(userProvider(params.other)); // Jisko follow/unfollow kiya, uska data refresh hoga
    ref.invalidate(userProvider(params.me));    // Aapka (current user) data refresh hoga

    // Lists ko bhi refresh rakhein (taake followers/following list screen bhi update rahe)
    ref.invalidate(followersProvider(params.other));
    ref.invalidate(followingProvider(params.me));
  }
}


// class FollowNotifier extends StateNotifier<bool> {
//   final Ref ref;
//   final FollowParams params;

//   FollowNotifier(this.ref, this.params) : super(false) {
//     check();
//   }

//   Future<void> check() async {
//     if (params.me.isEmpty || params.other.isEmpty) return;
//     state = await ref
//         .read(followServiceProvider)
//         .isFollowing(params.me, params.other);
//   }

//   Future<void> toggle() async {
//     if (params.me.isEmpty || params.other.isEmpty) return;
    
//     final service = ref.read(followServiceProvider);
    
//     // Optimistic Update: UI ko foran badal dein taake lag na aaye
//     final oldState = state;
//     state = !oldState;

//     try {
//       if (oldState) {
//         // Unfollow Logic
//         await service.unfollow(
//           me: params.me,
//           other: params.other,
//         );
//       } else {
//         // Follow Logic
//         await service.follow(
//           me: params.me,
//           other: params.other,
//           myData: params.myData,
//         );
//       }

//       //FIXED: Database update hone ke baad fresh data fetch karne ke liye delay lazmi hai
//       await Future.delayed(const Duration(milliseconds: 500));

//       // Dono users ka data bilkul alag se fresh refresh karein
//       ref.invalidate(userProvider(params.other)); 
//       ref.invalidate(userProvider(params.me));    

//       // Lists ko refresh karein
//       ref.invalidate(followersProvider(params.other));
//       ref.invalidate(followingProvider(params.me));

//     } catch (e) {
//       // Agar error aaye toh purani state wapas le aayein
//       state = oldState;
//       print("Error in toggle follow: $e");
//     }
//   }
// }

// class FollowNotifier extends StateNotifier<bool> {
//   final Ref ref;
//   final FollowParams params;

//   FollowNotifier(this.ref, this.params) : super(false) {
//     check();
//   }

//   Future<void> check() async {
//     if (params.me.isEmpty || params.other.isEmpty) return;
    
//     // Check karein ke current user samne wale ko follow kar raha hai ya nahi
//     state = await ref
//         .read(followServiceProvider)
//         .isFollowing(params.me, params.other);
//   }

//   Future<void> toggle() async {
//     if (params.me.isEmpty || params.other.isEmpty) return;

//     final service = ref.read(followServiceProvider);
    
//     // 1. Optimistic Update: UI ko instantly response dene ke liye true/false toggle karein
//     final oldState = state;
//     state = !oldState;

//     try {
//       if (oldState) {
//         // Agar pehle se following tha, toh unfollow karein
//         await service.unfollow(
//           me: params.me,
//           other: params.other,
//         );
//       } else {
//         // Agar following nahi tha, toh follow karein
//         await service.follow(
//           me: params.me,
//           other: params.other,
//           myData: params.myData,
//         );
//       }

//       // 2. 🔥 INSTANT REFRESH FIX: Database update hote hi live providers ko force refresh karein
//       // Jisse UI par 'Followers' count foran update ho jayega
//       ref.invalidate(userProvider(params.other)); // Samne wale user ka data refresh
//       ref.invalidate(userProvider(params.me));    // Aapka apna data refresh

//       // List providers ko bhi background mein clean karein
//       ref.invalidate(followersProvider(params.other));
//       ref.invalidate(followingProvider(params.me));

//     } catch (e) {
//       // Agar backend par koi error aaye, toh ui button ko wapas purani state par le aayein
//       state = oldState;
//       print("Error during follow toggle: $e");
//     }
//   }
// }