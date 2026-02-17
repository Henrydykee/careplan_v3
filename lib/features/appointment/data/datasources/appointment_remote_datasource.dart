import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../models/upcoming_appointments_response_model.dart';
import 'endpoint.dart';

abstract class AppointmentRemoteDataSource extends RemoteDataSource {
  Future<UpcomingAppointmentsResponseModel> getUpcomingAppointments({
    required String patientId,
    int page = 1,
    int limit = 20,
  });
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final NetworkService _networkService;
  AppointmentRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<UpcomingAppointmentsResponseModel> getUpcomingAppointments({
    required String patientId,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParameters = {
      'page': page,
      'limit': limit,
    };
    
    NetworkServiceResponse response = await _networkService.get(
      "${AppointmentEndpoints.getUpcomingAppointments}/$patientId/upcoming-appointments",
      queryParameters: queryParameters,
    );
    
    final data = handleNetworkResponse(response);
    
    // The API returns { "data": { ... } }, so we need to extract the data field
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return UpcomingAppointmentsResponseModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    
    // Fallback: if data is already the appointments data structure
    return UpcomingAppointmentsResponseModel.fromJson(data as Map<String, dynamic>);
  }
}


