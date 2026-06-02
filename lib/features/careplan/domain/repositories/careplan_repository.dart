import '../../data/models/care_team_response_model.dart';

abstract class CarePlanRepository {
  Future<CareTeamResponseModel> getCareTeam({
    required String patientId,
    int page = 1,
    int limit = 10,
  });
}
