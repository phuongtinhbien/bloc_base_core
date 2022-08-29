import 'package:bloc_base_core/src/network/app_token_storage.dart';
import 'package:bloc_base_core/src/network/network_config.dart';

abstract class AppBuildMode {
  final BuildMode mode;

  final AppTokenStorage appTokenStorage;

  AppBuildMode(this.mode, this.appTokenStorage);

  Map<String, dynamic> get variables;
}
