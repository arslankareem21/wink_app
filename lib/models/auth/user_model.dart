import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
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
  final bool hasPassword;

  // New fields - all nullable so old users don't break
  final String? website;
  final String? category;
  final String? description;
  final String? location;
  final String? collaborationEmail;

  

  const UserModel({
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
    required this.authProvider,
    this.hasPassword = false,
    // New optional fields
    this.website,
    this.category,
    this.description,
    this.location,
    this.collaborationEmail,
  });

  Map<String, dynamic> toMap() => {
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
        'hasPassword': hasPassword,
        // New fields - only save if not null
        if (website != null) 'website': website,
        if (category != null) 'category': category,
        if (description != null) 'description': description,
        if (location != null) 'location': location,
        if (collaborationEmail != null) 'collaborationEmail': collaborationEmail,
      };

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return UserModel(
      userId: data['userId'] as String? ?? doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      username: data['username'] as String? ?? '',
      profileImageUrl: data['profileImageUrl'] as String?,
      bio: data['bio'] as String?,
      followersCount: data['followersCount'] as int? ?? 0,
      followingCount: data['followingCount'] as int? ?? 0,
      postsCount: data['postsCount'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      authProvider: data['authProvider'] as String? ?? 'email',
      hasPassword: data['hasPassword'] as bool? ?? false,
      // New fields - default to null if not in Firestore
      website: data['website'] as String?,
      category: data['category'] as String?,
      description: data['description'] as String?,
      location: data['location'] as String?,
      collaborationEmail: data['collaborationEmail'] as String?,
    );
  }

  UserModel copyWith({
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
    bool? hasPassword,
    String? website,
    String? category,
    String? description,
    String? location,
    String? collaborationEmail,
  }) {
    return UserModel(
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
      hasPassword: hasPassword ?? this.hasPassword,
      website: website ?? this.website,
      category: category ?? this.category,
      description: description ?? this.description,
      location: location ?? this.location,
      collaborationEmail: collaborationEmail ?? this.collaborationEmail,
    );
  }
}