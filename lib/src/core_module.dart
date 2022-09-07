import 'package:bloc_base_core/src/device/device_info_service.dart';
import 'package:bloc_base_core/src/device/network_info_service.dart';
import 'package:bloc_base_core/src/network/app_token_storage.dart';
import 'package:injectable/injectable.dart';

import 'data/data.dart';
import 'device/package_service.dart';

@module
abstract class CoreModule {
  /// "Register an app token storage with the app storage."
  ///
  /// Args:
  ///   storage (AppStorage): The storage object that will be used to store the
  /// tokens.
  @preResolve
  Future<AppTokenStorage> registerAppTokenStorage(AppStorage storage) =>
      AppTokenStorage.init(storage);

  /// "Register the package info service with the app storage."
  ///
  /// Args:
  ///   storage (AppStorage): The storage object that will be used to store the
  /// package information.
  @preResolve
  Future<PackageService> registerPackageInfo(AppStorage storage) =>
      PackageService.init(storage);

  /// "Register the DeviceInfoService with the AppStorage."
  ///
  /// Args:
  ///   storage (AppStorage): The storage service that will be used to store the
  /// device information.
  @preResolve
  Future<DeviceInfoService> registerDeviceInfo(AppStorage storage) =>
      DeviceInfoService.init(storage);

  /// A getter that returns a new instance of the NetworkInfoService.
  NetworkInfoService get networkInfo => NetworkInfoService();
}
