import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkInfoService {
  final InternetConnectionChecker checker =
      InternetConnectionChecker.createInstance();

  /// A getter that returns a Future<bool> that is the result of the
  /// checker.hasConnection.
  Future<bool> get hasConnection => checker.hasConnection;
}
