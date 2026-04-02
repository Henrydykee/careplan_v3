import 'get_notifications.dart';
import 'mark_notifications_read.dart';
import 'register_push_token.dart';

class NotificationUseCases {
  final GetNotifications getNotifications;
  final RegisterPushToken registerPushToken;
  final MarkNotificationsRead markNotificationsRead;

  NotificationUseCases({
    required this.getNotifications,
    required this.registerPushToken,
    required this.markNotificationsRead,
  });
}
