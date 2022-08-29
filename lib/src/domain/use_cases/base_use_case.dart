import 'package:bloc_base_core/src/data/base_exception.dart';
import 'package:bloc_base_core/src/domain/entities/use_case_param.dart';
import 'package:bloc_base_core/src/utils/logger/logger_tool.dart';

abstract class BaseUseCase<P extends UseCaseParam, R> {
  Future<R> call([P? params]);

  void onError(Object? e, [StackTrace? stackTrace]) {
    Log.e('', e, stackTrace);
    if (e is TimeoutException ||
        e is ConnectionException ||
        e is ServerException ||
        e is UnauthorizedException ||
        e is ServerException) {}
  }
}

abstract class CompletableUseCase<P extends UseCaseParam>
    extends BaseUseCase<P, void> {}

abstract class NoParamUseCase<R> extends BaseUseCase<UseCaseParam, R> {}
