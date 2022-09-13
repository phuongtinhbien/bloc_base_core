import 'package:bloc_base_core/bloc_base_core.dart';
import 'package:example/app/app_config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: false, // default
  asExtension: false,
)
GetIt configureDependencies(
    {required GetIt getIt,
      String? environment,
      EnvironmentFilter? environmentFilter}) =>
    $initGetIt(getIt,
        environment: environment, environmentFilter: environmentFilter);

class AppConfig {
  static Future<void> init(BuildMode mode) async {

    await initDependencies(mode);

    configLogging();
  }

  static Future<void> initDependencies(BuildMode mode) async {
    final getIt = await configureCoreDependencies(environment: mode.value);

    configureDependencies(getIt: getIt, environment: mode.value);
  }

  static void configLogging() {
    LogTool().init(filter: ProductionFilter(), output: ConsoleOutput());
  }
}