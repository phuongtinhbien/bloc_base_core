import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final _analytics = FirebaseAnalytics.instance;
  late final FirebaseAnalyticsObserver observer;

  FirebaseAnalyticsService() {
    observer = FirebaseAnalyticsObserver(analytics: _analytics);
  }

  void sendAnalyticsEvent(
      {required String eventName, required Map<String, dynamic>? parameters}) {
    _analytics.logEvent(name: eventName, parameters: parameters);
  }
}
