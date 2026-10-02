import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../platform/env_config.dart';

class SentryManager {
  /// Can be overridden at build time: --dart-define=SENTRY_DSN=<dsn> (pass an empty value to disable Sentry).
  static const String _dsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: 'https://64aa4ffacd9249a1b992a0b868ab1d4f@o4504436526022656.ingest.us.sentry.io/4504456820359168',
  );

  static const List<String> _sensitiveHeaders = ['authorization', 'cookie', 'x-api-key', 'token'];

  /// Initializes Sentry and chains Flutter framework errors to both Sentry and Crashlytics.
  /// Call after [EnvConfig] and Firebase are initialized.
  static Future<void> init() async {
    await SentryFlutter.init((options) {
      options.dsn = _dsn;
      options.environment = EnvConfig.isProduction() ? 'production' : 'staging';
      options.debug = kDebugMode;
      options.sendDefaultPii = false;
      options.attachScreenshot = false;
      options.tracesSampleRate = EnvConfig.isProduction() ? 0.2 : 1.0;
      options.beforeSend = _scrubEvent;
    });

    // Sentry installs its own FlutterError.onError during init; forward to Crashlytics as well.
    final sentryHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      sentryHandler?.call(details);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
  }

  /// Reports an uncaught zone error to both Sentry and Crashlytics.
  static void recordZoneError(Object error, StackTrace stack) {
    Sentry.captureException(error, stackTrace: stack);
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  }

  static SentryEvent? _scrubEvent(SentryEvent event, Hint hint) {
    final request = event.request;
    if (request == null) return event;
    // Rebuild the request without body, cookies or auth headers — they may carry patient data or tokens.
    return event.copyWith(
      request: SentryRequest(
        url: request.url,
        method: request.method,
        apiTarget: request.apiTarget,
        headers: Map.fromEntries(
          request.headers.entries.where((h) => !_sensitiveHeaders.contains(h.key.toLowerCase())),
        ),
      ),
    );
  }
}
