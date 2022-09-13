part of 'network_checker_cubit.dart';

@immutable
class NetworkCheckerState {
  final InternetConnectionStatus status;

  const NetworkCheckerState({this.status = InternetConnectionStatus.connected});
}
