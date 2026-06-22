class UserModel {
  final String uid;
  final String username;
  final String displayName;
  final String bio;
  final String profileImageUrl;
    final String name;
        final String category;
     final String description;
  final String location;
    final String website;

  final String collaborationEmail;


  final int followersCount;
  final int followingCount;
  final int postsCount;

  UserModel({
    required this.uid,
    required this.username,
    required this.displayName,
    required this.bio,
    required this.profileImageUrl,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount, required this.name, required this.category, required this.description, required this.location, required this.collaborationEmail, required this.website,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      bio: map['bio'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      postsCount: map['postsCount'] ?? 0, name: map['name']??'',
       category:  map['category'] ?? '',
        description:  map['description'] ?? '',
         location:  map['location'] ?? '',
          collaborationEmail:  map['collaborationEmail'] ?? '', 
          website: map['website'] ??'',
    );
  }
}