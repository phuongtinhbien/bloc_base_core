import 'dart:async';

import 'package:dio/dio.dart' as dio;

class NetworkMonitor extends dio.Interceptor {
  final NetworkEventList eventList;
  final _requests = <dio.RequestOptions, NetworkEvent>{};

  NetworkMonitor({NetworkEventList? eventList})
      : eventList = eventList ?? NetworkLogger.instance;

  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    final event = NetworkEvent.now(
      request: options.toRequest(),
    );
    _requests[options] = event;
    eventList.add(event);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    dio.Response response,
    dio.ResponseInterceptorHandler handler,
  ) {
    final req = response.requestOptions;
    var event = _requests[req];
    if (event != null) {
      _requests.remove(req);
      event.response = response.toResponse();
      eventList.updated(event);
    } else {
      eventList.add(NetworkEvent.now(
        request: req.toRequest(),
        response: response.toResponse(),
      ));
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioError err, dio.ErrorInterceptorHandler handler) {
    final req = err.requestOptions;
    var event = _requests[req];
    if (event != null) {
      _requests.remove(req);
      eventList.updated(event..error = err.toNetworkError());
    } else {
      eventList.add(NetworkEvent.now(
        request: req.toRequest(),
        response: err.response?.toResponse(),
        error: err.toNetworkError(),
      ));
    }
    super.onError(err, handler);
  }
}

extension _RequestOptionsX on dio.RequestOptions {
  MonitorRequest toRequest() => MonitorRequest(
        uri: uri.toString(),
        data: data,
        method: method,
        headers: Headers(headers.entries.map(
          (kv) => MapEntry(kv.key, '${kv.value}'),
        )),
      );
}

extension _ResponseX on dio.Response {
  MonitorResponse toResponse() => MonitorResponse(
        data: data,
        statusCode: statusCode ?? -1,
        statusMessage: statusMessage ?? 'unkown',
        headers: Headers(
          headers.map.entries.fold<List<MapEntry<String, String>>>(
            [],
            (p, e) => p..addAll(e.value.map((v) => MapEntry(e.key, v))),
          ),
        ),
      );
}

extension _DioErrorX on dio.DioError {
  NetworkError toNetworkError() => NetworkError(message: toString());
}

/// Network event log entry.
class NetworkEvent {
  NetworkEvent({this.request, this.response, this.error, this.timestamp});

  NetworkEvent.now({this.request, this.response, this.error})
      : timestamp = DateTime.now();

  MonitorRequest? request;
  MonitorResponse? response;
  NetworkError? error;
  DateTime? timestamp;
}

/// Used for storing [MonitorRequest] and [MonitorResponse] headers.
class Headers {
  Headers(Iterable<MapEntry<String, String>> entries)
      : entries = entries.toList();

  Headers.fromMap(Map<String, String> map)
      : entries = map.entries as List<MapEntry<String, String>>;

  final List<MapEntry<String, String>> entries;

  bool get isNotEmpty => entries.isNotEmpty;

  bool get isEmpty => entries.isEmpty;

  Iterable<T> map<T>(T Function(String key, String value) cb) =>
      entries.map((e) => cb(e.key, e.value));
}

/// Http request details.
class MonitorRequest {
  MonitorRequest({
    required this.uri,
    required this.method,
    required this.headers,
    this.data,
  });

  final String uri;
  final String method;
  final Headers headers;
  final dynamic data;
}

/// Http response details.
class MonitorResponse {
  MonitorResponse({
    required this.headers,
    required this.statusCode,
    required this.statusMessage,
    this.data,
  });

  final Headers headers;
  final int statusCode;
  final String statusMessage;
  final dynamic data;
}

/// Network error details.
class NetworkError {
  NetworkError({required this.message});

  final String message;

  @override
  String toString() => message;
}

class NetworkEventList {
  final events = <NetworkEvent>[];
  final _controller = StreamController<UpdateEvent>.broadcast();

  /// A source of asynchronous network events.
  Stream<UpdateEvent> get stream => _controller.stream;

  /// Notify dependents that [event] is updated.
  void updated(NetworkEvent event) {
    _controller.add(UpdateEvent(event));
  }

  /// Add [event] to [events] list and notify dependents.
  void add(NetworkEvent event) {
    events.insert(0, event);
    _controller.add(UpdateEvent(event));
  }

  /// Clear [events] and notify dependents.
  void clear() {
    events.clear();
    _controller.add(const UpdateEvent.clear());
  }

  /// Dispose resources.
  void dispose() {
    _controller.close();
  }
}

/// Event notified by [NetworkEventList.stream].
class UpdateEvent {
  const UpdateEvent(this.event);

  const UpdateEvent.clear() : event = null;

  final NetworkEvent? event;
}

/// Network logger interface.
class NetworkLogger extends NetworkEventList {
  static final NetworkLogger instance = NetworkLogger();
}
