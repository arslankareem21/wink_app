import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileUserModel {
  final String userId;
  final String name;
    final String displayname;

  final String email;
  final String username;
  final String? profileImageUrl;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authProvider;

  ProfileUserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.username,
    this.profileImageUrl,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.authProvider, required this.displayname,
  });

  ProfileUserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? username,
    String? profileImageUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authProvider,
  }) {
    return ProfileUserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authProvider: authProvider ?? this.authProvider,
       displayname: displayname ?? this.displayname, 
     // displayname: displayname ?? this.displayname,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'authProvider': authProvider,
    };
  }

  factory ProfileUserModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProfileUserModel(
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'],
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      postsCount: data['postsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      authProvider: data['authProvider'] ?? 'email', 
      displayname: data['userId'] ??'',
    );
  }
}