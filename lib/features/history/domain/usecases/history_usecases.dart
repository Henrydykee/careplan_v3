import 'get_billing_history.dart';
import 'get_current_careplan.dart';
import 'get_notes_history.dart';
import 'get_session_history.dart';

class HistoryUseCases {
  GetBillingHistory getBillingHistory;
  GetNotesHistory getNotesHistory;
  GetSessionHistory getSessionHistory;
  GetCurrentCarePlan getCurrentCarePlan;

  HistoryUseCases(
    this.getBillingHistory,
    this.getNotesHistory,
    this.getSessionHistory,
    this.getCurrentCarePlan,
  );
}
