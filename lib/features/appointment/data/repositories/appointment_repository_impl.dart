import '../../../../core/utils/data/guarded_datasource_calls.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_datasource.dart';
import '../models/upcoming_appointments_response_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource _remoteDataSource;

  AppointmentRepositoryImpl(this._remoteDataSource);

  @override
  Future<UpcomingAppointmentsResponseModel> getUpcomingAppointments({
    required String patientId,
    int page = 1,
    int limit = 20,
  }) async {
    return await guardedApiCall<UpcomingAppointmentsResponseModel>(
      () => _remoteDataSource.getUpcomingAppointments(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
      source: "getUpcomingAppointments",
      showNetworkError: true,
    );
  }
}
