import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../models/notifications_response_model.dart';
import 'endpoint.dart';

abstract class NotificationsRemoteDataSource extends RemoteDataSource {
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

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final NetworkService _networkService;

  NotificationsRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<NotificationsResponseModel> getNotifications({
    int page = 1,
    int limit = 20,
    String status = 'all',
  }) async {
    final queryParameters = {
      'page': page,
      'limit': limit,
      'status': status,
    };

    NetworkServiceResponse response = await _networkService.get(
      NotificationEndpoints.getNotifications,
      queryParameters: queryParameters,
    );

    final data = handleNetworkResponse(response);

    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return NotificationsResponseModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    return NotificationsResponseModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> registerPushToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
    String? appVersion,
  }) async {
    final body = <String, dynamic>{
      'token': token,
      'platform': platform,
    };
    if (deviceId != null) body['deviceId'] = deviceId;
    if (deviceName != null) body['deviceName'] = deviceName;
    if (appVersion != null) body['appVersion'] = appVersion;

    NetworkServiceResponse response = await _networkService.post(
      NotificationEndpoints.registerPushToken,
      body: body,
    );

    handleNetworkResponse(response);
  }

  @override
  Future<void> markAsRead({required List<String> notificationIds}) async {
    NetworkServiceResponse response = await _networkService.patch(
      NotificationEndpoints.markAsRead,
      body: {'notificationIds': notificationIds},
    );

    handleNetworkResponse(response);
  }
}
