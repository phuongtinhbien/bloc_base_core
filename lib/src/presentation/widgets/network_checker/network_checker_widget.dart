import 'package:bloc_base_core/src/presentation/widgets/network_checker/network_checker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


typedef NetworkCheckerBuilder = Widget Function(
    BuildContext context, bool connected, Widget? child);

/// It's a widget that uses a builder to build a widget based on the current network
/// status
class NetworkCheckerWidget extends StatelessWidget {
  final Widget? child;
  final NetworkCheckerBuilder builder;

  const NetworkCheckerWidget({Key? key, required this.builder, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCheckerCubit, NetworkCheckerState>(
        bloc: GetIt.I<NetworkCheckerCubit>(),
        builder: (_, state) {
          final connected = state.status == InternetConnectionStatus.connected;
          return builder(_, connected, child);
        });
  }
}
