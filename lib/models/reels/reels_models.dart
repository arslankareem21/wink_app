
class ReelModel {
  final String videoUrl;
  final String username;
  final String profileUrl;
  final String caption;
  final String musicName;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;

  ReelModel({
    required this.videoUrl,
    required this.username,
    this.profileUrl = 'https://ui-avatars.com/api/?name=User',
    required this.caption,
    this.musicName = 'Original Audio',
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
  });

  String? get id => null;

  ReelModel copyWith({
    String? videoUrl,
    String? username,
    String? profileUrl,
    String? caption,
    String? musicName,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
  }) {
    return ReelModel(
      videoUrl: videoUrl ?? this.videoUrl,
      username: username ?? this.username,
      profileUrl: profileUrl ?? this.profileUrl,
      caption: caption ?? this.caption,
      musicName: musicName ?? this.musicName,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}