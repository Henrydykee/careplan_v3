import '../../../../core/di/di_config.dart';
import '../../data/datasources/history_remote_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../presentation/state/history_provider.dart';
import '../repositories/history_repository.dart';
import '../usecases/history_usecases.dart';
import '../usecases/get_billing_history.dart';
import '../usecases/get_notes_history.dart';
import '../usecases/get_session_history.dart';

Future<void> historyInjector() async {
  inject.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(inject()),
  );
  inject.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(inject()),
  );
  inject.registerLazySingleton<GetBillingHistory>(
    () => GetBillingHistory(inject()),
  );
  inject.registerLazySingleton<GetNotesHistory>(
    () => GetNotesHistory(inject()),
  );
  inject.registerLazySingleton<GetSessionHistory>(
    () => GetSessionHistory(inject()),
  );
  inject.registerLazySingleton<HistoryUseCases>(
    () => HistoryUseCases(
      inject(),
      inject(),
      inject(),
    ),
  );
  inject.registerLazySingleton<HistoryProvider>(
    () => HistoryProvider(inject()),
  );
}
