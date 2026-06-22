// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthUserModel {
//   final String userId;
//   final String name;
//   final String email;
//   final String username;
//   final String? profileImageUrl;
//   final String? bio;
//   final int followersCount;
//   final int followingCount;
//   final int postsCount;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String authProvider; // email / google

//   AuthUserModel({
//     required this.userId,
//     required this.name,
//     required this.email,
//     required this.username,
//     this.profileImageUrl,
//     this.bio,
//     this.followersCount = 0,
//     this.followingCount = 0,
//     this.postsCount = 0,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.authProvider,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'name': name,
//       'email': email,
//       'username': username,
//       'profileImageUrl': profileImageUrl,
//       'bio': bio,
//       'followersCount': followersCount,
//       'followingCount': followingCount,
//       'postsCount': postsCount,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'updatedAt': Timestamp.fromDate(updatedAt),
//       'authProvider': authProvider,
//     };
//   }

//   factory AuthUserModel.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     return AuthUserModel(
//       userId: data['userId'],
//       name: data['name'],
//       email: data['email'],
//       username: data['username'],
//       profileImageUrl: data['profileImageUrl'],
//       bio: data['bio'],
//       followersCount: data['followersCount'] ?? 0,
//       followingCount: data['followingCount'] ?? 0,
//       postsCount: data['postsCount'] ?? 0,
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//       updatedAt: (data['updatedAt'] as Timestamp).toDate(),
//       authProvider: data['authProvider'] ?? 'email',
//     );
//   }
// }