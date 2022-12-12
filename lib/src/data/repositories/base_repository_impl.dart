import 'dart:async';

import 'package:bloc_base_core/src/data/base_exception.dart';
import 'package:bloc_base_core/src/domain/repositories/base_repository.dart';

class BaseRepositoryImpl implements BaseRepository {
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
