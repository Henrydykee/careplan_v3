import '../../data/models/notifications_response_model.dart';

abstract class NotificationRepository {
  Future<NotificationsResponseModel> getNotifications({
    int page = 1,
    int limit = 20,
    String status = 'all',
  });

  Future<void> registerPushToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
    String? appVersion,
  });

  Future<void> markAsRead({required List<String> notificationIds});
}
