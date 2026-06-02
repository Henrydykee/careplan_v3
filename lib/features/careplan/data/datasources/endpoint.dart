class CarePlanEndpoints {
  static String addLongTermGoal = "assessment/long-term";
  static String addStressor = "assessment/stressors";
  static String getCarePlanHistory = "careplan/patient/history";
  static String getK10History = "careplan/k10/history";
  static String getActiveCarePlan = "careplan/patient";
  static String getActiveCarePlanSummary = "careplan";
  static String getCarePlanTeam = "user/updated-careplan-team";

  /// GET {{base_url}}/careteams/:id?page=1&limit=10
  static String getCareTeam(String patientId) => "careteams/$patientId";
}


