import '../../../../core/di/di_config.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notifications_read.dart';
import '../../domain/usecases/notification_usecases.dart';
import '../../domain/usecases/register_push_token.dart';
import '../../presentation/state/notification_provider.dart';

Future<void> notificationInjector() async {
  inject.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(inject()),
  );
  inject.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(inject()),
  );
  inject.registerLazySingleton<GetNotifications>(
    () => GetNotifications(inject()),
  );
  inject.registerLazySingleton<RegisterPushToken>(
    () => RegisterPushToken(inject()),
  );
  inject.registerLazySingleton<MarkNotificationsRead>(
    () => MarkNotificationsRead(inject()),
  );
  inject.registerLazySingleton<NotificationUseCases>(
    () => NotificationUseCases(
      getNotifications: inject(),
      registerPushToken: inject(),
      markNotificationsRead: inject(),
    ),
  );
  inject.registerLazySingleton<NotificationProvider>(
    () => NotificationProvider(inject()),
  );
}
