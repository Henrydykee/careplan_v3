import '../../../../core/utils/data/guarded_datasource_calls.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';
import '../models/billing_history_response_model.dart';
import '../models/notes_history_response_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource _remoteDataSource;

  HistoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<BillingHistoryResponseModel> getBillingHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  }) async {
    return await guardedApiCall<BillingHistoryResponseModel>(
      () => _remoteDataSource.getBillingHistory(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
      source: "getBillingHistory",
      showNetworkError: true,
    );
  }

  @override
  Future<NotesHistoryResponseModel> getNotesHistory({
    required String patientId,
    int page = 1,
    int limit = 10,
  }) async {
    return await guardedApiCall<NotesHistoryResponseModel>(
      () => _remoteDataSource.getNotesHistory(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
      source: "getNotesHistory",
      showNetworkError: true,
    );
  }
}
