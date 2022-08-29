abstract class BaseFailure extends Error {
  final int? code;
  final String? message;

  BaseFailure({this.code, this.message});
}

class NoInternetFailure extends BaseFailure {
  NoInternetFailure();
}

class UnExpectedFailure extends BaseFailure {
  UnExpectedFailure({super.message});
}
