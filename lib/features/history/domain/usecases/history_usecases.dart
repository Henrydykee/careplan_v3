import 'get_billing_history.dart';
import 'get_notes_history.dart';

class HistoryUseCases {
  GetBillingHistory getBillingHistory;
  GetNotesHistory getNotesHistory;

  HistoryUseCases(
    this.getBillingHistory,
    this.getNotesHistory,
  );
}
