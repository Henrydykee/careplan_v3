

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../features/auth/presentation/state/auth_provider.dart';
import '../../../features/onboarding/presentation/state/onboarding_provider.dart';
import '../../../features/appointment/presentation/state/appointment_provider.dart';
import '../../../features/history/presentation/state/history_provider.dart';
import '../../di/di_config.dart';

class ProviderInitializer {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<OnboardingProvider>(create: (_) => OnboardingProvider(inject())),
    ChangeNotifierProvider<AuthenticationProvider>(create: (_) => AuthenticationProvider(inject())),
    ChangeNotifierProvider<AppointmentProvider>(create: (_) => AppointmentProvider(inject())),
    ChangeNotifierProvider<HistoryProvider>(create: (_) => HistoryProvider(inject())),
    // ChangeNotifierProvider<TransactionProvider>(create: (_) => TransactionProvider(inject())),
    // ChangeNotifierProvider<CardProvider>(create: (_) => CardProvider(inject())),
    // ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider(inject())),
  ];
}
