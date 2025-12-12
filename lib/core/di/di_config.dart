import 'package:get_it/get_it.dart';
import 'package:careplan/core/di/core_di.dart';

import '../../features/auth/domain/di/auth_injector.dart';

GetIt inject = GetIt.instance;
/// Registration of service dependencies with  service locator GetIt
///
/// Add any such dependency here
Future<void> initInjectors()  async {
  await coreInjector();
  await authInjector();
}
