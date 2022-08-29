// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'src/core_module.dart' as _i9;
import 'src/data/data.dart' as _i5;
import 'src/data/data_sources/app_storage.dart' as _i3;
import 'src/device/device_info_service.dart' as _i6;
import 'src/device/network_info_service.dart' as _i7;
import 'src/device/package_service.dart' as _i8;
import 'src/network/app_token_storage.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final coreModule = _$CoreModule();
  gh.singleton<_i3.AppStorage>(_i3.AppStorage());
  await gh.factoryAsync<_i4.AppTokenStorage>(
      () => coreModule.registerAppTokenStorage(get<_i5.AppStorage>()),
      preResolve: true);
  await gh.factoryAsync<_i6.DeviceInfoService>(
      () => coreModule.registerDeviceInfo(get<_i5.AppStorage>()),
      preResolve: true);
  gh.factory<_i7.NetworkInfoService>(() => coreModule.networkInfo);
  await gh.factoryAsync<_i8.PackageService>(
      () => coreModule.registerPackageInfo(get<_i5.AppStorage>()),
      preResolve: true);
  return get;
}

class _$CoreModule extends _i9.CoreModule {}
