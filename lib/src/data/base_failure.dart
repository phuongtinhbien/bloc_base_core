abstract class BaseFailure extends Error {
  final int? code;
  final String? message;

  BaseFailure({this.code, this.message});
}

