import '../../data/models/upcoming_appointments_response_model.dart';

abstract class AppointmentRepository {
  Future<UpcomingAppointmentsResponseModel> getUpcomingAppointments({
    required String patientId,
    int page = 1,
    int limit = 20,
  });
}
