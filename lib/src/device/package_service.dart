import 'package:bloc_base_core/src/data/data_sources/app_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageService {
  final PackageInfo packageInfo;

  PackageService(this.packageInfo);

  static Future<PackageService> init(AppStorage storage) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final packageService = PackageService(packageInfo);
    storage.write('package_version', packageService.version);
    return packageService;
  }

  String get version {
    final regex = RegExp(r'[0-9].[0-9].[1-9]');
    final v = packageInfo.version;
    if (regex.allMatches(v).isNotEmpty) {
      return v;
    } else {
      return RegExp(r'[0-9].[0-9]').stringMatch(v) ?? '';
    }
  }
}
