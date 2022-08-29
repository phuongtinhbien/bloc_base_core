import 'dart:io';

import 'package:bloc_base_core/src/data/constants/sharef_key.dart';
import 'package:bloc_base_core/src/data/data_sources/app_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final BaseDeviceInfo deviceInfo;

  final String deviceId;

  final String userAgent;

  DeviceInfoService(this.deviceInfo, this.deviceId, this.userAgent);

  static Future<DeviceInfoService> init(AppStorage storage) async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;

    final deviceId = await getDeviceId(storage, deviceInfo);

    final userAgent = genUserAgent(storage, deviceInfo);
    return DeviceInfoService(deviceInfo, deviceId, userAgent);
  }

  /// Returns device information for the current platform.
  String? get deviceName {
    if (Platform.isAndroid) {
      return (deviceInfo as AndroidDeviceInfo).host;
    } else if (Platform.isIOS) {
      return (deviceInfo as IosDeviceInfo).name;
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String genUserAgent(AppStorage storage, BaseDeviceInfo deviceInfo) {
    const keyStorage = SharefKey.userAgent;
    var userAgent = '';
    if (Platform.isAndroid) {
      final androidInfo = deviceInfo as AndroidDeviceInfo;
      final release = androidInfo.version.release;
      final sdkInt = androidInfo.version.sdkInt;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;

      userAgent = 'Android $release(SDK $sdkInt)-$manufacturer-$model';
    } else {
      final iosInfo = deviceInfo as IosDeviceInfo;
      final systemName = iosInfo.systemName;
      final version = iosInfo.systemVersion;
      final name = iosInfo.name;
      userAgent = '$systemName $version-Apple-$name';
    }
    storage.write(keyStorage, userAgent);
    return userAgent;
  }

  static Future<String> getDeviceId(
      AppStorage storage, BaseDeviceInfo deviceInfo) async {
    const keyStorage = SharefKey.deviceId;
    var value = await storage.read(keyStorage) ?? '';
    if (value.isNotEmpty) {
      return value;
    } else {
      if (Platform.isIOS) {
        final iosDeviceInfo = deviceInfo as IosDeviceInfo;
        value = iosDeviceInfo.identifierForVendor ?? '';
      } else {
        final androidDeviceInfo = deviceInfo as AndroidDeviceInfo;
        value = androidDeviceInfo.id ?? '';
      }
      await storage.write(keyStorage, value);
      return value;
    }
  }
}
