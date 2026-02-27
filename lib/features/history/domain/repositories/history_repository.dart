import '../../data/models/billing_history_response_model.dart';
import '../../data/models/care_plan_history_item_model.dart';
import '../../data/models/notes_history_response_model.dart';
import '../../data/models/session_history_response_model.dart';

abstract class HistoryRepository {
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

  Future<SessionHistoryResponseModel> getSessionHistory({
    required String patientId,
    int page = 1,
    int limit = 10,
  });

  Future<CarePlanHistoryItemModel?> getCurrentCarePlan({
    required String patientId,
  });
}
