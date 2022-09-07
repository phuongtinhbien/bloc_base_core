import 'package:bloc_base_core/src/data/models/user_token_model.dart';
import 'package:bloc_base_core/src/network/app_token_storage.dart';
import 'package:bloc_base_core/src/network/network_config.dart';
import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';

import 'network_http_client_adapter.dart';

abstract class NetworkApiProvider<T> {
  /// A class that contains the baseUrl, connectTimeout, receiveTimeout, and
  /// sendTimeout.
  final NetWorkMode mode;

  /// A global configuration.
  final Dio dio = Dio();

  /// A class that stores the token.
  final AppTokenStorage appTokenStorage;

  /// A function that returns a map.
  final TokenHeaderBuilder<UserTokenModel>? tokenHeaderBuilder;

  /// A class that automatically adds the token to the header and refreshes the
  /// token when the token expires.
  /// Used to cancel the request.
  late final Fresh<UserTokenModel> freshToken;

  /// This is a dynamic header that can be added to the dio interceptors.
  final CancelToken cancelToken = CancelToken();

  final Interceptor? dynamicHeader;

  /// Used to refresh the token.
  final Dio? tokenDio;

  /// Used to set the httpAdapter.
  final NetworkHttpClientAdapter? httpAdapter;

  NetworkApiProvider(this.mode, this.appTokenStorage,
      {this.tokenHeaderBuilder,
      this.dynamicHeader,
      this.tokenDio,
      this.httpAdapter}) {
    if (httpAdapter != null) {
      dio.httpClientAdapter = httpAdapter!;
    }
    dio.options = BaseOptions(
      baseUrl: mode.baseUrl,
      contentType: 'application/json; charset=utf-8',
      connectTimeout: mode.connectTimeout,
      receiveTimeout: mode.receiveTimeout,
      sendTimeout: mode.connectTimeout,
    );
    _initToken();
    initDynamicHeader();
    addInterceptors();
  }

  /// > When the request is sent, the token is automatically added to the header,
  /// and the token is automatically refreshed when the token expires
  ///
  /// Returns:
  ///   A function that returns a map.
  void _initToken() {
    freshToken = Fresh<UserTokenModel>(
        refreshToken: refreshToken,
        tokenStorage: appTokenStorage,
        shouldRefresh: shouldRefresh,
        tokenHeader: tokenHeaderBuilder ??
            (token) {
              return {
                'Authorization': 'Bearer ${token.accessToken}',
              };
            },
        httpClient: tokenDio ?? dio);
    dio.interceptors.add(freshToken);
  }

  /// If the dynamic header is not null, add it to the dio interceptors
  void initDynamicHeader() {
    if (dynamicHeader != null) {
      dio.interceptors.add(dynamicHeader!);
    }
  }

  void addInterceptors() {}

  T get client;

  /// This is a function that returns a new token.
  Future<UserTokenModel> refreshToken(UserTokenModel? token, Dio dio);

  /// This is a function that determines whether the token needs to be refreshed.
  bool shouldRefresh(Response? response);

  /// "Closes the stream,
  /// causing the stream to generate a done event."
  ///
  /// Args:
  ///   force (bool): If true, the connection will be closed even if there are
  /// pending messages. The default is false. Defaults to false
  void close({bool force = false}) {
    dio.close(force: force);
  }
}
