abstract class BaseException implements Exception {
  final String message;

  BaseException(this.message);

  @override
  String toString() => message;
}

class ConnectionException extends BaseException {
  ConnectionException(super.message);
}

class ServerException extends BaseException {
  ServerException(super.message);
}

class TimeoutException extends BaseException {
  TimeoutException(super.message);
}

class UnauthorizedException extends BaseException {
  UnauthorizedException(super.message);
}
