import 'dart:ui';

import 'package:bloc_base_core/bloc_base_core.dart';
import 'package:example/app/dialogs/app_dialog.dart';
import 'package:flutter/material.dart';

class InitApp extends StatelessWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final route = GetIt.I<Routes>();
    // final themeBloc = ThemeManagerCubit(
    //     light: GetIt.I<ChatAppTheme>().light,
    //     dark: GetIt.I<ChatAppTheme>().light);
    // return EasyLocalization(
    //   supportedLocales: AppLocalization().supportedLocales,
    //   path: AppLocalization().path,
    //   startLocale: AppLocalization().supportedLocales.first,
    //   assetLoader: AppAssetLoader(),
    //   fallbackLocale: AppLocalization().fallbackLocale,
    //   child: BlocBuilder<ThemeManagerCubit, ThemeManagerState>(
    //       bloc: themeBloc,
    //       builder: (context, state) {
    //         return MaterialApp.router(
    //           theme: state.theme.data,
    //           themeMode: state.mode,
    //           useInheritedMediaQuery: true,
    //           routeInformationProvider: route.router.routeInformationProvider,
    //           routeInformationParser: route.router.routeInformationParser,
    //           routerDelegate: route.router.routerDelegate,
    //           localizationsDelegates: context.localizationDelegates,
    //           supportedLocales: context.supportedLocales,
    //           locale: context.locale,
    //           scrollBehavior: const CupertinoScrollBehavior(),
    //           builder: (context, child) {
    //             return App(child: child);
    //           },
    //         );
    //       }),
    // );
    return App(
      child: MaterialApp(
        home: TestDialogWidget(),
      ),
    );
  }
}

class TestDialogWidget extends StatefulWidget {
  const TestDialogWidget({Key? key}) : super(key: key);

  @override
  State<TestDialogWidget> createState() => _TestDialogWidgetState();
}

class _TestDialogWidgetState extends State<TestDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            for (var i = 0; i < 10; i++) {
              getIt<AppDialog>().show(context,
                  config: DialogConfig(
                      type: 'test',
                      request: DialogRequest(
                          description: '1',
                          onMainButtonTap: () {},
                          mainButtonTitle: '')));
            }
          },
          child: Text('Test Dialog'),
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  final Widget? child;

  const App({Key? key, this.child}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(AppMediaQuery());
    AppMediaQuery().init(window);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(AppMediaQuery());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: AppMediaQuery().data,
      child: widget.child ?? const SizedBox.shrink(),
    );
  }
}
