import 'dart:async';

import 'package:bloc_base_core/src/domain/entities/use_case_param.dart';
import 'package:bloc_base_core/src/utils/logger/logger_tool.dart';
import 'package:get_it/get_it.dart';

/// `BaseUseCase` is an abstract class that defines a `call` method that takes an
/// optional parameter of type `UseCaseParam` and returns a `Future` of type `R`
abstract class BaseUseCase<P extends UseCaseParam, R> extends Disposable {
  Future<R> call([P? params]);

  void onError(Object? e, [StackTrace? stackTrace]) {
    Log.e('', e, stackTrace);
  }

  @override
  FutureOr onDispose() {
  }
}

/// In this case, no responses were needed. Hence, void. Otherwise, change to appropriate.
/// `CompletableUseCase` is a class that extends `BaseUseCase` and takes a
/// `UseCaseParam` as a parameter
abstract class CompletableUseCase<P extends UseCaseParam>
    extends BaseUseCase<P, void> {}

/// In this case, no parameters were needed. Hence, void. Otherwise, change to appropriate.
/// `NoParamUseCase` is a class that extends `BaseUseCase` and takes no parameters
abstract class NoParamUseCase<R> extends BaseUseCase<UseCaseParam, R> {}


