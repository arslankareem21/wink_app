class FollowUserModel {
  final String uid;
    final String name;

  final String username;
  final String displayName;
  final String profileImageUrl;

  FollowUserModel({
    required this.uid,
    required this.username,
    required this.displayName,
    required this.profileImageUrl, required this.name,
  });

  factory FollowUserModel.fromMap(Map<String, dynamic> map) {
    return FollowUserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
       name:map['name'] ?? '',
    );
  }
}