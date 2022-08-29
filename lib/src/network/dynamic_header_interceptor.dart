import 'package:dio/dio.dart';

abstract class DynamicHeaderInterceptor extends Interceptor {
  DynamicHeaderInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    createHeader().then((value) {
      options.headers.addAll(value);
    }).whenComplete(() {
      return super.onRequest(options, handler);
    });
  }

  Future<Map<String, dynamic>> createHeader();
}
