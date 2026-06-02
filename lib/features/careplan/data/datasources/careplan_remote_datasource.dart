import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../models/care_team_response_model.dart';
import 'endpoint.dart';

abstract class CarePlanRemoteDataSource extends RemoteDataSource {
  Future<CareTeamResponseModel> getCareTeam({
    required String patientId,
    int page = 1,
    int limit = 10,
  });
}

class CarePlanRemoteDataSourceImpl implements CarePlanRemoteDataSource {
  final NetworkService _networkService;

  CarePlanRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<CareTeamResponseModel> getCareTeam({
    required String patientId,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParameters = {
      'page': page,
      'limit': limit,
    };

    NetworkServiceResponse response = await _networkService.get(
      CarePlanEndpoints.getCareTeam(patientId),
      queryParameters: queryParameters,
    );

    final data = handleNetworkResponse(response);

    // The API returns { "data": { "careTeam": [...] } }, so unwrap `data`.
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return CareTeamResponseModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    // Fallback: response already at the careTeam container level.
    return CareTeamResponseModel.fromJson(data as Map<String, dynamic>);
  }
}
