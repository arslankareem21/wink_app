// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:wink_app/presentation/widgets/circle_avatar.dart';

// class FollowFollowingScreen extends StatefulWidget {
//   final String targetUserId;

//   //final String userId;
//   final int initialIndex;

//   const FollowFollowingScreen({
//     super.key,
//     // required this.userId,
//     this.initialIndex = 0,
//     required this.targetUserId,
//   });

//   @override
//   State<FollowFollowingScreen> createState() => _FollowFollowingScreenState();
// }

// class _FollowFollowingScreenState extends State<FollowFollowingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       initialIndex: widget.initialIndex,
//       child: Scaffold(
//         appBar: AppBar(
//           title: TabBar(
//             indicatorColor: Colors.amber,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               Tab(text: 'Followers'),
//               Tab(text: 'Following'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             UserListWidget(
//               userId: widget.targetUserId,
//               collectionName: 'followers',
//             ),
//             UserListWidget(
//               userId: widget.targetUserId,
//               collectionName: 'following',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class UserListWidget extends StatelessWidget {
//   final String userId;
//   final String collectionName;
//   const UserListWidget({
//     super.key,
//     required this.userId,
//     required this.collectionName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection(collectionName)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             height: 100,
//             width: 100,
//             child: CircularProgressIndicator(),
//           );
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Text(
//               collectionName == 'followers' ? 'no followers' : 'no following',
//               style: TextStyle(fontSize: 15),
//             ),
//           );
//         }

//         final data = snapshot.data!.docs;
//         return ListView.builder(
//           itemCount: data.length,
//           itemBuilder: (context, index) {
//             //Yahan INDEX hai kyunki yeh List bana raha hai

//             //FIX 1: Document ki ID se targetUserId nikaala
//             final String targetUserId = data[index].id;

//             return FutureBuilder<DocumentSnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(targetUserId)
//                   .get(),
//               builder: (context, snapshot) {
//                 //Yahan INDEX NAHI hai kyunki yeh sirf 1 user ka data hai
//                 if (!snapshot.hasData) {
//                   CircularProgressIndicator();
//                 }

//                 //Yeh error tab aata hai jab Dart ko pata nahi hota ke aapka data object ek Map / Dictionary hai (Map<String, dynamic>).
//                 //Firestore ka .data() method default mein ek Object? type return karta hai. Isiliye jab aap userData['name'] likhte hain, toh Dart bolta hai ke
//                 //"Object type par [] bracket operator use nahi ho sakta."
//                 //final userData = snapshot.data!.data() as Map<String, dynamic>?;

//                 if (snapshot.hasError ||
//                     !snapshot.hasData ||
//                     snapshot.data == null ||
//                     !snapshot.data!.exists) {
//                   return const SizedBox.shrink(); // Jab tak data na mile, crash na hone do
//                 }

//                 // // 3. Safe Map Extraction (Bina direct `!` use kiye)
//                 final rawData = snapshot.data?.data();
//                 if (rawData == null) {
//                   return const SizedBox.shrink();
//                 }

//                 final userData = rawData as Map<String, dynamic>;
//                 // //FIX 3: profileImg ko extract kiya userData Map se
//                 final String? profileImg =
//                     userData['profileImageUrl'] ?? userData['profilePic'];
//                 // //final user = usersList[index];
//                 //final String targetUserId = snapshot.data!.docs[index].id;
//                 final String currentUserId =
//                     FirebaseAuth.instance.currentUser?.uid ?? '';

//                 return ListTile(
//                   onTap: () {
//                     final currentUserId =
//                         FirebaseAuth.instance.currentUser?.uid;

//                     // Check karein agar click ki hui ID meri apni ID hai ya kisi aur ki
//                     if (targetUserId == currentUserId) {
//                       // Apni profile screen par bhejein
//                       context.pushNamed(' profile');
//                     } else {
//                       // Doosray user ki profile screen par targetUserId pass kar ke bhejein
//                       context.pushNamed(
//                         'profile ',
//                         extra: {'profileId': targetUserId},
//                       );
//                     }

//                     //   if (clickedUserId == currentUserId) {
//                     //           // Agar yeh meri apni profile hai, toh apni main profile par bhejen
//                     //           context.pushNamed(' profile');
//                     //         } else {
//                     //   context.pushNamed(
//                     //     'other user profile',
//                     //     extra: {'profileId': clickedUserId},
//                     //   );
//                     // }
//                   },
//                   leading: AppProfileAvatar(
//                     radius: 20.r,
//                     imageFile: null,
//                     profileImageUrl:
//                         profileImg, // Avatar image link pass kar diya
//                     onChangePhoto: () {},
//                   ),
//                   title: Text(
//                     userData?['name'] ??
//                         userData?['displayName'] ??
//                         ['username'] ??
//                         'User',
//                   ),
//                   subtitle: Text(
//                     '@${userData?['username'] ?? ''}',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FollowFollowingScreen extends StatelessWidget {
  final String userId; // Jis user ki following/followers dekhni hai
  final int initialIndex; // 0 for Followers, 1 for Following

  const FollowFollowingScreen({
    Key? key,
    required this.userId,
    this.initialIndex = 0,
    // required String targetUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DefaultTabController swipe aur tap gestures dono auto-handle karta hai
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        //backgroundColor: Colors.black, // App ki dark theme ke mutabiq
        appBar: AppBar(
          //backgroundColor: Colors.black,
          title: const Text(
            'Connections',
            //style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            // labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
        ),
        // TabBarView swipes between pages automatically
        body: TabBarView(
          children: [
            _UserListWidget(userId: userId, collectionName: 'followers'),
            _UserListWidget(userId: userId, collectionName: 'following'),
          ],
        ),
      ),
    );
  }
}

// // Reusable List Widget for both Followers and Following
// class _UserListWidget extends StatelessWidget {
//   final String userId;
//   final String collectionName; // 'followers' or 'following'

//   const _UserListWidget({required this.userId, required this.collectionName});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection(collectionName)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.white),
//           );
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Text(
//               collectionName == 'followers'
//                   ? 'No followers yet'
//                   : 'Not following anyone yet',
//               //style: const TextStyle(color: Colors.white54),
//             ),
//           );
//         }

//         final docs = snapshot.data!.docs;

//         return ListView.builder(
//           itemCount: docs.length,
//           itemBuilder: (context, index) {
            
// // 💡 MASTER FIX: Subcollection Document me se asli User ID nikali
//             final docData = docs[index].data() as Map<String, dynamic>?;
//             final String targetUserId = docData?['uid'] ??
//                 docData?['userId'] ??
//                 docData?['id'] ??
//                 docs[index].id;
//             // Fetch target user details from Firestore
//             return FutureBuilder<DocumentSnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(targetUserId)
//                   .get(),
//               builder: (context, userSnapshot) {
//                 if (!userSnapshot.hasData) {
//                   return const ListTile(
//                     title: Text(
//                       'Loading...',
//                       style: TextStyle(color: Colors.white30),
//                     ),
//                   );
//                 }

//                 var userData =
//                     userSnapshot.data!.data() as Map<String, dynamic>?;

//                 return ListTile(
//                   onTap: () {
//                     final currentUserId =
//                         FirebaseAuth.instance.currentUser?.uid;

//                     // Check karein agar click ki hui ID meri apni ID hai ya kisi aur ki
//                     if (targetUserId == currentUserId) {
//                       // Apni profile screen par bhejein
//                       context.pushNamed('profile');
//                     } else {
//                       // Doosray user ki profile screen par targetUserId pass kar ke bhejein
//                       context.pushNamed(
//                         'other user profile',
//                         extra: {'profileId': targetUserId},
//                       );
//                     }
//                   },
//                   leading: CircleAvatar(
//                     backgroundImage: NetworkImage(
//                       userData?['profileImageUrl'] ??
//                           userData?['profilePic'] ??
//                           'https://ui-avatars.com/api/?name=${userData?['username'] ?? 'User'}',
//                     ),
//                   ),
//                   title: Text(
//                     userData?['name'] ??
//                         userData?['displayName'] ??
//                         userData?['username'] ??
//                         'User',
//                     style: const TextStyle(
//                       //color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Text(
//                     '@${userData?['username'] ?? ''}',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
// Reusable List Widget for both Followers and Following
class _UserListWidget extends StatelessWidget {
  final String userId;
  final String collectionName; // 'followers' or 'following'

  const _UserListWidget({required this.userId, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(collectionName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              collectionName == 'followers'
                  ? 'No followers yet'
                  : 'Not following anyone yet',
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            // 💡 MASTER FIX: Subcollection Document me se asli User ID nikali
            final docData = docs[index].data() as Map<String, dynamic>?;
            final String targetUserId = docData?['uid'] ??
                docData?['userId'] ??
                docData?['id'] ??
                docs[index].id;

            // Fetch target user details from Firestore main 'users' collection
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(targetUserId)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text(
                      'Loading...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                if (!userSnapshot.hasData ||
                    userSnapshot.data == null ||
                    !userSnapshot.data!.exists) {
                  return const SizedBox.shrink(); // Broken references ke liye crash safety
                }

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;

                return ListTile(
                  onTap: () {
                    final currentUserId =
                        FirebaseAuth.instance.currentUser?.uid;

                    // Apni ID VS Doosre User ki ID Check
                    if (targetUserId == currentUserId) {
                      context.pushNamed('profile');
                    } else {
                      context.pushNamed(
                        'other user profile',
                        extra: {'profileId': targetUserId},
                      );
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userData?['profileImageUrl'] ??
                          userData?['profilePic'] ??
                          'https://ui-avatars.com/api/?name=${userData?['username'] ?? 'User'}',
                    ),
                  ),
                  title: Text(
                    userData?['name'] ??
                        userData?['displayName'] ??
                        userData?['username'] ??
                        'User',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '@${userData?['username'] ?? ''}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}