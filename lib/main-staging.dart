import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'core/data/enums/type_enums.dart';
import 'core/di/di_config.dart';
import 'core/platform/env_config.dart';
import 'package:careplan/core/platform/string_constants.dart' as Constants;

import 'core/presentation/state/provider_initializer.dart';
import 'core/presentation/widgets/router.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig(
      flavor: Env.STAGING,
      values: EnvVar(
        baseUrl: Constants.STAGING_BASE_URL,
      ));
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initInjectors();
  runApp(careplan());
}

class careplan extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: ProviderInitializer.providers,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey:  router.navigatorKey,
            theme: ThemeData(
                fontFamily: 'avenir',
                useMaterial3: false,
                appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
                textTheme: const TextTheme(
                  displayLarge: TextStyle(fontFamily: 'avenir'),
                  displayMedium: TextStyle(fontFamily: 'avenir'),
                  displaySmall: TextStyle(fontFamily: 'avenir'),
                  headlineLarge: TextStyle(fontFamily: 'avenir'),
                  headlineMedium: TextStyle(fontFamily: 'avenir'),
                  headlineSmall: TextStyle(fontFamily: 'avenir'),
                  titleLarge: TextStyle(fontFamily: 'avenir'),
                  titleMedium: TextStyle(fontFamily: 'avenir'),
                  titleSmall: TextStyle(fontFamily: 'avenir'),
                  bodyLarge: TextStyle(fontFamily: 'avenir'),
                  bodyMedium: TextStyle(fontFamily: 'avenir'),
                  bodySmall: TextStyle(fontFamily: 'avenir'),
                  labelLarge: TextStyle(fontFamily: 'avenir'),
                  labelMedium: TextStyle(fontFamily: 'avenir'),
                  labelSmall: TextStyle(fontFamily: 'avenir'),
                ),
            ),
            home: SplashScreen(),
          ),
        ),
      ),
    );
  }
}

