import 'dart:io';

class CustomProxy {
  /// A string representing an IP address for the proxy server
  final String ipAddress;

  /// The port number for the proxy server
  /// Can be null if port is default.
  final int port;

  /// Set this to true
  /// - Warning: Setting this to true in production apps can be dangerous.
  /// Use with care!
  bool allowBadCertificates;

  /// Initializer
  CustomProxy(
      {required this.ipAddress,
      required this.port,
      this.allowBadCertificates = false});

  /// Initializer from string
  /// Note: Uses static method, rather than named init to
  /// allow final properties.
  static CustomProxy? fromString(
      {String? proxy, bool allowBadCertificates = false}) {
    // Check if valid
    if (proxy == null || proxy == '') {
      assert(
          false, 'Proxy string passed to CustomProxy.fromString() is invalid.');
      return null;
    }

    // Build and return
    final proxyParts = proxy.split(':');
    final ipAddress = proxyParts[0];
    final port = proxyParts.isNotEmpty ? int.tryParse(proxyParts[1]) : null;
    return CustomProxy(
        ipAddress: ipAddress,
        port: port!,
        allowBadCertificates: allowBadCertificates);
  }

  /// Enable the proxy
  void enable() {
    HttpOverrides.global = CustomProxyHttpOverride.withProxy(toString(),
        allowBadCertificates: allowBadCertificates);
    // AppStorage().dev.write(SharefKey.PROXY_KEY, toString());
  }

  /// Disable the proxy
  void disable() {
    HttpOverrides.global = null;
    // AppStorage().dev.remove(SharefKey.PROXY_KEY);
  }

  @override
  String toString() {
    var proxy = ipAddress;
    proxy += ':$port';
    return proxy;
  }
}

class CustomProxyHttpOverride extends HttpOverrides {
  /// The entire proxy server
  /// Format: "localhost:8888"
  final String proxyString;

  /// Set this to true
  /// - Warning: Setting this to true in production apps can be dangerous.
  /// Use with care!
  final bool allowBadCertificates;

  /// Initializer
  CustomProxyHttpOverride.withProxy(
    this.proxyString, {
    this.allowBadCertificates = false,
  });

  /// Override HTTP client creation
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        assert(proxyString.isNotEmpty,
            'You must set a valid proxy if you enable it!');
        return 'PROXY $proxyString;';
      }
      ..maxConnectionsPerHost
      ..badCertificateCallback =
          allowBadCertificates ? (cert, host, port) => true : null;
  }
}
