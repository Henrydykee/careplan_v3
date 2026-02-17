import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../models/billing_history_response_model.dart';
import '../models/notes_history_response_model.dart';
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
    int limit = 10,
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
      "${HistoryEndpoints.getBillingHistory}/$patientId/billing",
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
    int limit = 10,
  }) async {
    final queryParameters = {
      'page': page,
      'limit': limit,
    };

    NetworkServiceResponse response = await _networkService.get(
      "${HistoryEndpoints.getNotesHistory}/$patientId/notes",
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
}
