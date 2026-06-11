import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/notification_model.dart';

/// Global provider definition for the Notification Screen
final notificationViewModelProvider = StateNotifierProvider<NotificationViewModel, AsyncValue<List<AppNotificationModel>>>((ref) {
  return NotificationViewModel()..fetchNotifications();
});

class NotificationViewModel extends StateNotifier<AsyncValue<List<AppNotificationModel>>> {
  NotificationViewModel() : super(const AsyncValue.loading());

  /// Simulates fetching data from Firestore stream or collection
  Future<void> fetchNotifications() async {
    state = const AsyncValue.loading();
    try {
      // In production, hook up your Firestore collection snapshots here:
      // _firestoreService.getNotificationsStream().listen((data) { ... });
      
      final now = DateTime.now();
      final mockData = [
        AppNotificationModel(
          id: '1',
          userId: 'u1',
          username: 'Zoe',
          type: NotificationType.comment,
          message: 'tagged you in a comment.',
          postImage: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          timestamp: now.subtract(const Duration(minutes: 45)),
        ),
        AppNotificationModel(
          id: '2',
          userId: 'u2',
          username: 'kristin_w',
          type: NotificationType.follow,
          message: 'started following you.',
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
        AppNotificationModel(
          id: '3',
          userId: 'u3',
          username: 'max_vibe',
          type: NotificationType.like,
          message: 'liked your short video.',
          postImage: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          timestamp: now.subtract(const Duration(days: 1, hours: 4)),
        ),
      ];

      state = AsyncValue.data(mockData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Handles swiping and instant local deletion synchronized with Firestore
  Future<void> deleteNotification(String id) async {
    final currentList = state.value ?? [];
    
    // Instant UI Update (Snappy performance)
    state = AsyncValue.data(currentList.where((item) => item.id != id).toList());

    try {
      // Fire-and-forget background delete to Firebase Firestore
      // await _firestoreRef.doc(id).delete();
    } catch (e) {
      // Optional: Roll back or show error banner if Firebase write drops
      state = AsyncValue.data(currentList);
    }
  }
}

/// Helper extension to cleanly compute list grouping partitions without pollution
extension NotificationFilterExtension on List<AppNotificationModel> {
  List<AppNotificationModel> get filterToday {
    final now = DateTime.now();
    return where((n) =>
        n.timestamp.year == now.year &&
        n.timestamp.month == now.month &&
        n.timestamp.day == now.day).toList();
  }

  List<AppNotificationModel> get filterEarlier {
    final now = DateTime.now();
    return where((n) => !(
        n.timestamp.year == now.year &&
        n.timestamp.month == now.month &&
        n.timestamp.day == now.day)).toList();
  }
}