import '../../../../core/utils/data/guarded_datasource_calls.dart';
import '../../domain/repositories/careplan_repository.dart';
import '../datasources/careplan_remote_datasource.dart';
import '../models/care_team_response_model.dart';

class CarePlanRepositoryImpl implements CarePlanRepository {
  final CarePlanRemoteDataSource _remoteDataSource;

  CarePlanRepositoryImpl(this._remoteDataSource);

  @override
  Future<CareTeamResponseModel> getCareTeam({
    required String patientId,
    int page = 1,
    int limit = 10,
  }) async {
    return await guardedApiCall<CareTeamResponseModel>(
      () => _remoteDataSource.getCareTeam(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
      source: "getCareTeam",
      showNetworkError: true,
    );
  }
}
