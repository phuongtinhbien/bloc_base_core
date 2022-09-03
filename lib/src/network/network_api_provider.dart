import 'package:bloc_base_core/src/data/models/user_token_model.dart';
import 'package:bloc_base_core/src/network/app_token_storage.dart';
import 'package:bloc_base_core/src/network/network_config.dart';
import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';

import 'network_http_client_adapter.dart';

abstract class NetworkApiProvider<T> {
  final NetWorkMode mode;

  final Dio dio = Dio();

  final AppTokenStorage appTokenStorage;

  final TokenHeaderBuilder<UserTokenModel>? tokenHeaderBuilder;

  late final Fresh<UserTokenModel> freshToken;

  final CancelToken cancelToken = CancelToken();

  final Interceptor? dynamicHeader;

  final Dio? tokenDio;

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

  void initDynamicHeader() {
    if (dynamicHeader != null) {
      dio.interceptors.add(dynamicHeader!);
    }
  }

  void addInterceptors() {}

  T get client;

  Future<UserTokenModel> refreshToken(UserTokenModel? token, Dio dio);

  bool shouldRefresh(Response? response);

  void close({bool force = false}) {
    dio.close(force: force);
  }
}
