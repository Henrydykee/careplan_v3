import '../../../../core/utils/data/guarded_datasource_calls.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notifications_response_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<NotificationsResponseModel> getNotifications({
    int page = 1,
    int limit = 20,
    String status = 'all',
  }) async {
    return await guardedApiCall<NotificationsResponseModel>(
      () => _remoteDataSource.getNotifications(
        page: page,
        limit: limit,
        status: status,
      ),
      source: "getNotifications",
    );
  }

  @override
  Future<void> registerPushToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
    String? appVersion,
  }) async {
    return await guardedApiCall<void>(
      () => _remoteDataSource.registerPushToken(
        token: token,
        platform: platform,
        deviceId: deviceId,
        deviceName: deviceName,
        appVersion: appVersion,
      ),
      source: "registerPushToken",
    );
  }

  @override
  Future<void> markAsRead({required List<String> notificationIds}) async {
    return await guardedApiCall<void>(
      () => _remoteDataSource.markAsRead(notificationIds: notificationIds),
      source: "markAsRead",
    );
  }
}
