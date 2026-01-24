import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import 'endpoint.dart';

abstract class NotificationRemoteDataSource extends RemoteDataSource {
  Future<String> getUserNotification();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NetworkService _networkService;
  NotificationRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<String> getUserNotification() async {
    NetworkServiceResponse response = await _networkService.get(NotificationEndpoints.getUserNotification);
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }
}

