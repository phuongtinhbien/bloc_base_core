import 'dart:io';

import 'package:bloc_base_core/src/data/constants/sharef_key.dart';
import 'package:bloc_base_core/src/data/data_sources/app_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final BaseDeviceInfo deviceInfo;

 /// A unique identifier for the device.
   final String deviceId;

  /// A string that is sent to the server with every request. It is used to identify
  /// the device and the browser.
  final String userAgent;

  DeviceInfoService(this.deviceInfo, this.deviceId, this.userAgent);

  /// It initializes the device info service.
  ///
  /// Args:
  ///   storage (AppStorage): The storage object that will be used to store the
  /// device information.
  static Future<DeviceInfoService> init(AppStorage storage) async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;

    final deviceId = await getDeviceId(storage, deviceInfo);

    final userAgent = genUserAgent(storage, deviceInfo);
    return DeviceInfoService(deviceInfo, deviceId, userAgent);
  }

  /// Returns device information for the current platform.
  /// A getter method that returns the device name.
  String? get deviceName {
    if (Platform.isAndroid) {
      return (deviceInfo as AndroidDeviceInfo).host;
    } else if (Platform.isIOS) {
      return (deviceInfo as IosDeviceInfo).name;
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// It generates a user agent string for the app
  ///
  /// Args:
  ///   storage (AppStorage): The AppStorage object that you created in the previous
  /// step.
  ///   deviceInfo (BaseDeviceInfo): The device information object.
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

  /// > Get the device id from the storage, if it's not there, get it from the
  /// device info and save it to the storage
  ///
  /// Args:
  ///   storage (AppStorage): The storage object that you created in the previous
  /// step.
  ///   deviceInfo (BaseDeviceInfo): This is the device information object that we
  /// get from the device_info package.
  ///
  /// Returns:
  ///   A Future<String>
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
