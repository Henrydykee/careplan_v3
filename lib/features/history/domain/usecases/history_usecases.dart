import 'get_billing_history.dart';
import 'get_notes_history.dart';
import 'get_session_history.dart';

class HistoryUseCases {
  GetBillingHistory getBillingHistory;
  GetNotesHistory getNotesHistory;
  GetSessionHistory getSessionHistory;

  HistoryUseCases(
    this.getBillingHistory,
    this.getNotesHistory,
    this.getSessionHistory,
  );
}
