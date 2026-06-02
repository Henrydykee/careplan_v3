import 'package:get_it/get_it.dart';
import 'package:careplan/core/di/core_di.dart';

import '../../features/account/domain/di/account_injector.dart';
import '../../features/auth/domain/di/auth_injector.dart';
import '../../features/appointment/domain/di/appointment_injector.dart';
import '../../features/card/domain/di/card_injector.dart';
import '../../features/careplan/domain/di/careplan_injector.dart';
import '../../features/history/domain/di/history_injector.dart';
import '../../features/notifications/domain/di/notification_injector.dart';

GetIt inject = GetIt.instance;
/// Registration of service dependencies with  service locator GetIt
///
/// Add any such dependency here
Future<void> initInjectors()  async {
  await coreInjector();
  await authInjector();
  await accountInjector();
  await appointmentInjector();
  await historyInjector();
  await careplanInjector();
  await cardInjector();
  await notificationInjector();
}
