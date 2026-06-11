enum NotificationType { follow, like, comment, mention }

class AppNotificationModel {
  final String id;
  final String username;
  final String? userAvatar; // Cloudinary URL or null
  final NotificationType type;
  final String message;
  final String? postImage;  // Cloudinary URL if a post thumbnail is linked
  final DateTime timestamp;

  const AppNotificationModel({
    required this.id,
    required this.username,
    this.userAvatar,
    required this.type,
    required this.message,
    this.postImage,
    required this.timestamp, required String userId,
  });
}