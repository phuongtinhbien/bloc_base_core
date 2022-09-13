import 'package:bloc/bloc.dart';
import 'package:bloc_base_core/src/device/device.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'network_checker_state.dart';

@LazySingleton()
class NetworkCheckerCubit extends Cubit<NetworkCheckerState> {
  final NetworkInfoService service;

  NetworkCheckerCubit(this.service) : super(const NetworkCheckerState()) {
    onInit();
  }

  Future<void> onInit() async {
    final status = await service.checker.connectionStatus;
    emit(NetworkCheckerState(status: status));
    service.checker.onStatusChange.listen(listenOnStatusChange);
  }

  void listenOnStatusChange(InternetConnectionStatus status) {
    emit(NetworkCheckerState(status: status));
  }
}
