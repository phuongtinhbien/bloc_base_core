import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef OnHttpClientCreate = HttpClient? Function(HttpClient client);

/// The default HttpClientAdapter for Dio.
class NetworkHttpClientAdapter implements HttpClientAdapter {
  /// [Dio] will create HttpClient when it is needed.
  /// If [onHttpClientCreate] is provided, [Dio] will call
  /// it when a HttpClient created.
  OnHttpClientCreate? onHttpClientCreate;

  HttpClient? _defaultHttpClient;

  bool _closed = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) async {
    if (_closed) {
      throw Exception(
          "Can't establish connection after [HttpClientAdapter] closed!");
    }
    final httpClient = _configHttpClient(cancelFuture, options.connectTimeout);
    final reqFuture = httpClient.openUrl(options.method, options.uri);

    void _throwConnectingTimeout() {
      throw DioError(
        requestOptions: options,
        error: 'Connecting timed out [${options.connectTimeout}ms]',
        type: DioErrorType.connectTimeout,
      );
    }

    late HttpClientRequest request;
    try {
      request = await reqFuture;
      if (options.connectTimeout > 0) {
        request = await reqFuture
            .timeout(Duration(milliseconds: options.connectTimeout));
      } else {
        request = await reqFuture;
      }

      //Set Headers
      options.headers.forEach((k, v) {
        if (v != null) request.headers.set(k, '$v');
      });
    } on SocketException catch (e) {
      if (e.message.contains('timed out')) {
        _throwConnectingTimeout();
      }
      rethrow;
    } on TimeoutException {
      _throwConnectingTimeout();
    }

    request
      ..followRedirects = options.followRedirects
      ..maxRedirects = options.maxRedirects;

    if (requestStream != null) {
      // Transform the request data
      var future = request.addStream(requestStream);
      if (options.sendTimeout > 0) {
        future = future.timeout(Duration(milliseconds: options.sendTimeout));
      }
      try {
        await future;
      } on TimeoutException {
        request.abort();
        throw DioError(
          requestOptions: options,
          error: 'Sending timeout[${options.sendTimeout}ms]',
          type: DioErrorType.sendTimeout,
        );
      }
    }

    // [receiveTimeout] represents a timeout during data transfer! That is to say the
    // client has connected to the server.
    final receiveStart = DateTime.now().millisecondsSinceEpoch;
    var future = request.close();
    if (options.receiveTimeout > 0) {
      future = future.timeout(Duration(milliseconds: options.receiveTimeout));
    }
    late HttpClientResponse responseStream;
    try {
      responseStream = await future;
    } on TimeoutException {
      throw DioError(
        requestOptions: options,
        error: 'Receiving data timeout[${options.receiveTimeout}ms]',
        type: DioErrorType.receiveTimeout,
      );
    }

    final stream =
        responseStream.transform<Uint8List>(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        if (options.receiveTimeout > 0 &&
            DateTime.now().millisecondsSinceEpoch - receiveStart >
                options.receiveTimeout) {
          sink.addError(
            DioError(
              requestOptions: options,
              error: 'Receiving data timeout[${options.receiveTimeout}ms]',
              type: DioErrorType.receiveTimeout,
            ),
          );
          responseStream.detachSocket().then((socket) => socket.destroy());
        } else {
          sink.add(Uint8List.fromList(data));
        }
      },
    ));

    final headers = <String, List<String>>{};
    responseStream.headers.forEach((key, values) {
      headers[key] = values;
    });
    return ResponseBody(
      stream,
      responseStream.statusCode,
      headers: headers,
      isRedirect:
          responseStream.isRedirect || responseStream.redirects.isNotEmpty,
      redirects: responseStream.redirects
          .map((e) => RedirectRecord(e.statusCode, e.method, e.location))
          .toList(),
      statusMessage: responseStream.reasonPhrase,
    );
  }

  /// If the cancelFuture is not null, then create a new HttpClient, otherwise use
  /// the default HttpClient.
  ///
  /// Args:
  ///   cancelFuture (Future): A future that will be completed when the request is
  /// cancelled.
  ///   timeout (int): The timeout in milliseconds.
  HttpClient _configHttpClient(Future? cancelFuture, int timeout) {
    final connectionTimeout =
        timeout > 0 ? Duration(milliseconds: timeout) : null;

    if (cancelFuture != null) {
      var httpClient = HttpClient()..userAgent = null;
      if (onHttpClientCreate != null) {
        httpClient = onHttpClientCreate!(httpClient) ?? httpClient;
      }
      httpClient.idleTimeout = const Duration(seconds: 0);
      cancelFuture.whenComplete(() {
        Future.delayed(const Duration(seconds: 0)).then((e) {
          try {
            httpClient.close(force: true);
          } catch (e) {
            //...
          }
        });
      });
      return httpClient..connectionTimeout = connectionTimeout;
    }
    if (_defaultHttpClient == null) {
      _defaultHttpClient = HttpClient();
      _defaultHttpClient!.idleTimeout = const Duration(seconds: 3);
      if (onHttpClientCreate != null) {
        _defaultHttpClient =
            onHttpClientCreate!(_defaultHttpClient!) ?? _defaultHttpClient;
      }
      _defaultHttpClient!.connectionTimeout = connectionTimeout;
    }
    return _defaultHttpClient!;
  }

  /// It resets the default http client to null
  void resetHttpClient() {
    _defaultHttpClient = null;
  }

  @override
  void close({bool force = false}) {
    _closed = _closed;
    _defaultHttpClient?.close(force: force);
  }
}
