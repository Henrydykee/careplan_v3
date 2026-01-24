import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import 'endpoint.dart';

abstract class AppointmentRemoteDataSource extends RemoteDataSource {
  Future<String> getUpcomingAppointments({required String userId});
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final NetworkService _networkService;
  AppointmentRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<String> getUpcomingAppointments({required String userId}) async {
    NetworkServiceResponse response = await _networkService.get("${AppointmentEndpoints.getUpcomingAppointments}/$userId");
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }
}


