enum BuildMode {
  demo('demo'),
  stage('stage'),
  live('live');

  final String value;

  const BuildMode(this.value);
}

abstract class NetWorkMode {
  /// A variable that is used to store the base url of the api.
  final String baseUrl;

  /// Used to authenticate the user.

  String apiKey;

  /// Used to store the name of the local database.

  String localDBName;

  /// Used to set the timeout for the connection.
  int connectTimeout;

  /// Used to set the timeout for the connection.
  int receiveTimeout;

  /// This is used to store the variables that are used in the api.
  Map<String, dynamic> variables;

  /// This is used to enable the network monitor.
  bool enableNetworkMonitor;

  NetWorkMode.internal(
      {required this.baseUrl,
      required this.apiKey,
      required this.localDBName,
      required this.connectTimeout,
      required this.receiveTimeout,
      required this.variables,
      this.enableNetworkMonitor = false});

  factory NetWorkMode({required BuildMode mode}) {
    switch (mode) {
      case BuildMode.live:
        return ProductionMode();
      case BuildMode.stage:
        return StagingMode();
      case BuildMode.demo:
        return DevelopmentMode();
    }
  }
}

/// > ProductionMode is a subclass of NetWorkMode
class ProductionMode extends NetWorkMode {
  ProductionMode(
      {String localDBName = 'local.db',
      String baseUrl = '',
      String apiKey = 'ff957763c54c44d8b00e5e082bc76cb0',
      int connectTimeout = 30000,
      int receiveTimeout = 30000,
      Map<String, dynamic> variables = const {}})
      : super.internal(
            baseUrl: baseUrl,
            apiKey: apiKey,
            localDBName: localDBName,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            variables: variables);
}

/// > StagingMode is a subclass of NetWorkMode
class StagingMode extends NetWorkMode {
  StagingMode(
      {String localDBName = 'local.db',
      String baseUrl = '',
      String apiKey = 'ff957763c54c44d8b00e5e082bc76cb0',
      int connectTimeout = 30000,
      int receiveTimeout = 30000,
      Map<String, dynamic> variables = const {}})
      : super.internal(
            baseUrl: baseUrl,
            apiKey: apiKey,
            localDBName: localDBName,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            variables: variables);
}

/// > DevelopmentMode is a subclass of NetWorkMode
class DevelopmentMode extends NetWorkMode {
  DevelopmentMode(
      {String localDBName = 'local.db',
      String baseUrl = '',
      String apiKey = 'ff957763c54c44d8b00e5e082bc76cb0',
      int connectTimeout = 30000,
      int receiveTimeout = 30000,
      Map<String, dynamic> variables = const {}})
      : super.internal(
            baseUrl: baseUrl,
            apiKey: apiKey,
            localDBName: localDBName,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            variables: variables,
            enableNetworkMonitor: true);
}
