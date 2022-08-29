import 'package:bloc_base_core/src/device/device_info_service.dart';
import 'package:bloc_base_core/src/device/network_info_service.dart';
import 'package:bloc_base_core/src/network/app_token_storage.dart';
import 'package:injectable/injectable.dart';

import 'data/data.dart';
import 'device/package_service.dart';

@module
abstract class CoreModule {
  @preResolve
  Future<AppTokenStorage> registerAppTokenStorage(AppStorage storage) =>
      AppTokenStorage.init(storage);

  @preResolve
  Future<PackageService> registerPackageInfo(AppStorage storage) =>
      PackageService.init(storage);

  @preResolve
  Future<DeviceInfoService> registerDeviceInfo(AppStorage storage) =>
      DeviceInfoService.init(storage);

  NetworkInfoService get networkInfo => NetworkInfoService();
}
