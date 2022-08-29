enum BuildMode {
  demo('demo'),
  stage('stage'),
  live('live');

  final String value;

  const BuildMode(this.value);
}

abstract class NetWorkMode {
  final String baseUrl;
  String apiKey;
  String localDBName;
  int connectTimeout;
  int receiveTimeout;
  Map<String, dynamic> variables;
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
