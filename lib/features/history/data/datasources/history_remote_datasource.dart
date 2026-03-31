import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../models/billing_history_response_model.dart';
import '../models/care_plan_history_item_model.dart';
import '../models/notes_history_response_model.dart';
import '../models/session_history_response_model.dart';
import 'endpoint.dart';

abstract class HistoryRemoteDataSource extends RemoteDataSource {
  Future<BillingHistoryResponseModel> getBillingHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  });

  Future<NotesHistoryResponseModel> getNotesHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  });

  Future<SessionHistoryResponseModel> getSessionHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  });

  Future<CarePlanHistoryItemModel?> getCurrentCarePlan({
    required String patientId,
  });
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final NetworkService _networkService;

  HistoryRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<BillingHistoryResponseModel> getBillingHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  }) async {
    final queryParameters = {
      'page': page,
      'limit': limit,
      'type': 'Billing',
    };

    NetworkServiceResponse response = await _networkService.get(
      HistoryEndpoints.getBillingHistory(patientId),
      queryParameters: queryParameters,
    );

    final data = handleNetworkResponse(response);

    // The API returns { "data": { "history": [...], ... } }, so we need to extract the data field
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return BillingHistoryResponseModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    // Fallback: if data is already the billing history data structure
    return BillingHistoryResponseModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<NotesHistoryResponseModel> getNotesHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  }) async {
    final queryParameters = {
      'page': page,
      'limit': limit,
    };

    NetworkServiceResponse response = await _networkService.get(
      HistoryEndpoints.getNotesHistory(patientId),
      queryParameters: queryParameters,
    );

    final data = handleNetworkResponse(response);

    // The API returns { "data": { "notes": [...], ... } }, so we need to extract the data field
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return NotesHistoryResponseModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    // Fallback: if data is already the notes history data structure
    return NotesHistoryResponseModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<SessionHistoryResponseModel> getSessionHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  }) async {
    final queryParameters = {
      'page': page,
      'limit': limit,
    };

    NetworkServiceResponse response = await _networkService.get(
      HistoryEndpoints.getSessionHistory(patientId),
      queryParameters: queryParameters,
    );

    final data = handleNetworkResponse(response);

    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return SessionHistoryResponseModel.fromJson(
          data['data'] as Map<String, dynamic>);
    }
    return SessionHistoryResponseModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<CarePlanHistoryItemModel?> getCurrentCarePlan({
    required String patientId,
  }) async {
    NetworkServiceResponse response = await _networkService.get(
      HistoryEndpoints.getCurrentCarePlan(patientId),
    );

    final data = handleNetworkResponse(response);

    Map<String, dynamic>? carePlanJson;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        carePlanJson = data['data'] as Map<String, dynamic>;
      } else {
        carePlanJson = data;
      }
    }

    if (carePlanJson == null) {
      return null;
    }

    final providerJson =
        carePlanJson['provider'] as Map<String, dynamic>? ?? {};
    final assessmentJson =
        carePlanJson['assessment'] as Map<String, dynamic>? ?? {};
    final shortTermJson =
        assessmentJson['shortTermGoal'] as Map<String, dynamic>? ?? {};
    final stressorsJson =
        assessmentJson['stressors'] as Map<String, dynamic>? ?? {};
    final therapyJson =
        carePlanJson['therapy'] as Map<String, dynamic>? ?? {};

    final providerFirstName = providerJson['firstName'] as String? ?? '';
    final providerLastName = providerJson['lastName'] as String? ?? '';
    final providerName = [providerFirstName, providerLastName]
        .where((e) => e.isNotEmpty)
        .join(' ');

    final diagnosisList = (carePlanJson['diagnosis'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final rating = carePlanJson['rating'] ?? assessmentJson['rating'];

    return CarePlanHistoryItemModel(
      type: null,
      status: carePlanJson['status'] as String?,
      createdAt: carePlanJson['createdAt'] as String?,
      id: carePlanJson['id'] as String?,
      provider: providerName.isNotEmpty ? providerName : null,
      providerType: providerJson['type'] as String?,
      diagnosis: diagnosisList,
      riskToSelf: carePlanJson['riskToSelf'] as String?,
      riskToOthers: carePlanJson['riskToOthers'] as String?,
      shortTermGoal: ShortTermGoalModel(
        timeline: shortTermJson['period']?.toString(),
        percent: shortTermJson['reductionLevel']?.toString(),
        text: shortTermJson['message'] as String?,
        id: assessmentJson['id'] as String?,
      ),
      longTermGoal: assessmentJson['longTermGoal'] as String?,
      therapy: TherapyModel(
        hasCBT: null,
        otherIntervention: therapyJson['otherInterventions'] as String?,
        hasSafetyPlanning: therapyJson['hasSafetyPlanning'] as bool?,
        id: null,
      ),
      homework: carePlanJson['homework'] as String?,
      abilityToCope: rating != null ? rating.toString() : null,
      stressors: StressorsModel(
        relationship: stressorsJson['relationship'] as bool?,
        work: stressorsJson['work'] as bool?,
        finances: stressorsJson['finances'] as bool?,
        physicalHealth: stressorsJson['physicalHealth'] as bool?,
        school: stressorsJson['school'] as bool?,
        alcohol: stressorsJson['alcohol'] as bool?,
        trauma: stressorsJson['trauma'] as bool?,
        housing: stressorsJson['housing'] as bool?,
        id: assessmentJson['id'] as String?,
      ),
    );
  }
}
