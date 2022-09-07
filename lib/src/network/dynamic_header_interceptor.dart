import 'package:dio/dio.dart';

/// It's an interceptor that allows you to create a header dynamically
abstract class DynamicHeaderInterceptor extends Interceptor {
  DynamicHeaderInterceptor();

  /// > Create a header, then add it to the request options, then call the super
  /// function
  ///
  /// Args:
  ///   options (RequestOptions): RequestOptions, which is the request configuration
  /// object.
  ///   handler (RequestInterceptorHandler): The handler is a function that is
  /// called when the request is complete.
  ///
  /// Returns:
  ///   The super class of the onRequest method.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    createHeader().then((value) {
      options.headers.addAll(value);
    }).whenComplete(() {
      return super.onRequest(options, handler);
    });
  }


  /// It's a function that returns a Header object.
  Future<Map<String, dynamic>> createHeader();
}
