import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final _analytics = FirebaseAnalytics.instance;
  late final FirebaseAnalyticsObserver observer;

  FirebaseAnalyticsService() {
    observer = FirebaseAnalyticsObserver(analytics: _analytics);
  }

  /// "Send an analytics event to Firebase Analytics with the given name and
  /// parameters."
  ///
  /// The `required` keyword is a Dart language feature that ensures that the
  /// function is called with the given parameters
  ///
  /// Args:
  ///   eventName (String): The name of the event.
  ///   parameters (Map<String, dynamic>): A Map<String, dynamic> of parameters and
  /// their values.
  void sendAnalyticsEvent(
      {required String eventName, required Map<String, dynamic>? parameters}) {
    _analytics.logEvent(name: eventName, parameters: parameters);
  }

  FirebaseAnalytics get analytics => _analytics;
}
