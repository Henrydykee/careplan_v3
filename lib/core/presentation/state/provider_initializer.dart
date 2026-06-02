

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../features/account/presentation/state/kyc_provider.dart';
import '../../../features/auth/presentation/state/auth_provider.dart';
import '../../../features/card/presentation/state/card_provider.dart';
import '../../../features/onboarding/presentation/state/onboarding_provider.dart';
import '../../../features/appointment/presentation/state/appointment_provider.dart';
import '../../../features/careplan/presentation/state/careplan_provider.dart';
import '../../../features/history/presentation/state/history_provider.dart';
import '../../../features/notifications/presentation/state/notification_provider.dart';
import '../../di/di_config.dart';

class ProviderInitializer {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<OnboardingProvider>(create: (_) => OnboardingProvider(inject())),
    ChangeNotifierProvider<AuthenticationProvider>(create: (_) => AuthenticationProvider(inject())),
    ChangeNotifierProvider<AppointmentProvider>(create: (_) => AppointmentProvider(inject())),
    ChangeNotifierProvider<HistoryProvider>(create: (_) => HistoryProvider(inject())),
    ChangeNotifierProvider<CarePlanProvider>(create: (_) => CarePlanProvider(inject())),
    ChangeNotifierProvider<CardProvider>(create: (_) => CardProvider(inject())),
    ChangeNotifierProvider<KycProvider>(create: (_) => inject<KycProvider>()),
    ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider(inject())),
  ];
}
