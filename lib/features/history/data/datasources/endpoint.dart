class HistoryEndpoints {
  /// GET {{base_url}}/patients/:id/billing?page=1&limit=15&type=Billing
  static String getBillingHistory(String patientId) => "patients/$patientId/billing";

  static String getNotesHistory(String patientId) => "patients/$patientId/notes";

  /// GET {{base_url}}/patients/:id/session-history?page=1&limit=10
  static String getSessionHistory(String patientId) =>
      "patients/$patientId/session-history";
}
