import '../../../../core/di/di_config.dart';
import '../../data/datasources/careplan_remote_datasource.dart';
import '../../data/repositories/careplan_repository_impl.dart';
import '../../presentation/state/careplan_provider.dart';
import '../repositories/careplan_repository.dart';
import '../usecases/careplan_usecases.dart';
import '../usecases/get_care_team.dart';

Future<void> careplanInjector() async {
  inject.registerLazySingleton<CarePlanRemoteDataSource>(
    () => CarePlanRemoteDataSourceImpl(inject()),
  );
  inject.registerLazySingleton<CarePlanRepository>(
    () => CarePlanRepositoryImpl(inject()),
  );
  inject.registerLazySingleton<GetCareTeam>(
    () => GetCareTeam(inject()),
  );
  inject.registerLazySingleton<CarePlanUseCases>(
    () => CarePlanUseCases(inject()),
  );
  inject.registerLazySingleton<CarePlanProvider>(
    () => CarePlanProvider(inject()),
  );
}
