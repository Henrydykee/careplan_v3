import 'package:firebase_analytics/firebase_analytics.dart';

class GoogleAnalyticsManager {
  static final GoogleAnalyticsManager _instance = GoogleAnalyticsManager._internal();

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: analytics);

  GoogleAnalyticsManager._internal();
  factory GoogleAnalyticsManager() => _instance;

  Future<void> logEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    await analytics.logEvent(name: eventName, parameters: parameters);
  }

  Future<void> logScreenView({required String screenName}) async {
    await analytics.logScreenView(screenName: screenName);
  }

  Future<void> setUserId(String userId) async {
    await analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await analytics.setUserProperty(name: name, value: value);
  }
}

final googleAnalytics = GoogleAnalyticsManager();
