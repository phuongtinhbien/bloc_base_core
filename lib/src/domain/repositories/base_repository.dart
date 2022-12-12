import 'dart:async';

import 'package:bloc_base_core/bloc_base_core.dart';

/// BaseRepository is an abstract class that has no members.
abstract class BaseRepository {
  /// This is a method that is used to determine if a call should be retried.
  bool shouldRetry(Exception e) ;

  /// A method that is used to call a function.
  Future<A> call<A>(FutureOr<A> Function() fn);

  /// A method that is used to call a function with retrying.
  Future<A> retryCall<A>(FutureOr<A> Function() fn,
      {Duration delayFactor = const Duration(milliseconds: 200),
        double randomizationFactor = 0.25,
        Duration maxDelay = const Duration(seconds: 20),
        int maxAttempts = 3,
        FutureOr<void> Function(Exception)? onRetry});

  /// A method that is used to handle errors.
  BaseException handleError(Object? e, [StackTrace? stackTrace]);
}

abstract class LocalBaseRepository extends BaseRepository {
  @override
  Future<A> call<A>(FutureOr<A> Function() fn) {
    // TODO: implement call
    throw UnimplementedError();
  }

  @override
  BaseException handleError(Object? e, [StackTrace? stackTrace]) {
    // TODO: implement handleError
    throw UnimplementedError();
  }

  @override
  Future<A> retryCall<A>(FutureOr<A> Function() fn, {Duration delayFactor = const Duration(milliseconds: 200), double randomizationFactor = 0.25, Duration maxDelay = const Duration(seconds: 20), int maxAttempts = 3, FutureOr<void> Function(Exception p1)? onRetry}) {
    // TODO: implement retryCall
    throw UnimplementedError();
  }

  @override
  bool shouldRetry(Exception e) {
    // TODO: implement shouldRetryRemote
    throw UnimplementedError();
  }

}
abstract class RemoteBaseRepository extends BaseRepository {
  @override
  Future<A> call<A>(FutureOr<A> Function() fn) {
    // TODO: implement call
    throw UnimplementedError();
  }

  @override
  BaseException handleError(Object? e, [StackTrace? stackTrace]) {
    // TODO: implement handleError
    throw UnimplementedError();
  }

  @override
  Future<A> retryCall<A>(FutureOr<A> Function() fn, {Duration delayFactor = const Duration(milliseconds: 200), double randomizationFactor = 0.25, Duration maxDelay = const Duration(seconds: 20), int maxAttempts = 3, FutureOr<void> Function(Exception p1)? onRetry}) {
    // TODO: implement retryCall
    throw UnimplementedError();
  }

  @override
  bool shouldRetry(Exception e) {
    // TODO: implement shouldRetryRemote
    throw UnimplementedError();
  }

}