import '../../../../core/di/di_config.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../repositories/account_repository.dart';
import '../usecases/account_usecases.dart';
import '../usecases/get_patients_note.dart';
import '../usecases/update_user_number.dart';
import '../usecases/verify_update_user_number.dart';

Future<void> accountInjector() async {
  inject.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(inject()),
  );
  inject.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(inject()),
  );
  inject.registerLazySingleton<UpdateUserNumber>(
    () => UpdateUserNumber(inject()),
  );
  inject.registerLazySingleton<VerifyUpdateUserNumber>(
    () => VerifyUpdateUserNumber(inject()),
  );
  inject.registerLazySingleton<GetPatientsNote>(
    () => GetPatientsNote(inject()),
  );
  inject.registerLazySingleton<AccountUseCases>(
    () => AccountUseCases(
      inject(),
      inject(),
      inject(),
    ),
  );
}
