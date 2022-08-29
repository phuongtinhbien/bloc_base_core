import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkInfoService {
  final InternetConnectionChecker checker =
      InternetConnectionChecker.createInstance();

  Future<bool> get hasConnection => checker.hasConnection;
}
