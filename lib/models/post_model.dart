class PostModel {
  final String userName;
  final String userImage;
  final String location;
  final String timeAgo;

  final String postImage;
  final String caption;

  final int likes;
  final int comments;

  const PostModel({
    required this.userName,
    required this.userImage,
    required this.location,
    required this.timeAgo,
    required this.postImage,
    required this.caption,
    required this.likes,
    required this.comments,
  });
}