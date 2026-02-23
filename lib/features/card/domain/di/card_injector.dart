import '../../../../core/di/di_config.dart';
import '../../data/datasources/card_remote_datasource.dart';
import '../../data/repositories/card_repository_impl.dart';
import '../repositories/card_repository.dart';
import '../usecases/card_usecases.dart';
import '../usecases/delete_card.dart';
import '../usecases/get_cards.dart';
import '../usecases/mark_default_card.dart';

Future<void> cardInjector() async {
  inject.registerLazySingleton<CardRemoteDataSource>(
    () => CardRemoteDataSourceImpl(inject()),
  );
  inject.registerLazySingleton<CardRepository>(
    () => CardRepositoryImpl(inject()),
  );
  inject.registerLazySingleton<GetCards>(() => GetCards(inject()));
  inject.registerLazySingleton<MarkDefaultCard>(
    () => MarkDefaultCard(inject()),
  );
  inject.registerLazySingleton<DeleteCard>(() => DeleteCard(inject()));
  inject.registerLazySingleton<CardUseCases>(
    () => CardUseCases(
      inject(),
      inject(),
      inject(),
    ),
  );
}
