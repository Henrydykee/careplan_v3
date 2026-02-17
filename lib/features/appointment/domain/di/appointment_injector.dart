import '../../../../core/di/di_config.dart';
import '../../data/datasources/appointment_remote_datasource.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/usecases/appointment_usecases.dart';
import '../../domain/usecases/get_upcoming_appointments.dart';
import '../../presentation/state/appointment_provider.dart';

Future<void> appointmentInjector() async {
  inject.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(inject()),
  );
  inject.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(inject()),
  );
  inject.registerLazySingleton<GetUpcomingAppointments>(
    () => GetUpcomingAppointments(inject()),
  );
  inject.registerLazySingleton<AppointmentUseCases>(
    () => AppointmentUseCases(inject()),
  );
  inject.registerLazySingleton<AppointmentProvider>(
    () => AppointmentProvider(inject()),
  );
}
