import 'package:bloc_base_core/src/presentation/bloc/base_bloc.dart';
import 'package:bloc_base_core/src/presentation/manager/theme/app_theme.dart';
import 'package:bloc_base_core/src/presentation/manager/theme/theme_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => throw UnimplementedError();
}

abstract class BaseScreenState<P extends StatefulWidget,
        T extends BaseBloc<BaseEvent, BaseState>> extends State<P>
    with AutomaticKeepAliveClientMixin {
  T get bloc => GetIt.I<T>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initBloc();
    });
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<T>();
    super.dispose();
  }

  void initBloc();

  AppTheme get currentTheme => GetIt.I<ThemeManagerCubit>().currentTheme;

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<T, BaseState>(
        bloc: bloc,
        listener: listenerBloc,
        listenWhen: listenWhen,
        buildWhen: buildWhen,
        builder: (context, state) {
          return OrientationBuilder(builder: (orientationContext, orientation) {
            if (orientation == Orientation.landscape) {
              return ScreenTypeLayout.builder(
                mobile: (layout) => buildLandscapeMobile(context, state),
                tablet: (layout) => buildLandscapeTablet(context, state),
              );
            }
            return ScreenTypeLayout.builder(
              mobile: (layout) => buildMobile(layout, state),
              tablet: (layout) => buildTablet(layout, state),
            );
          });
        },
      ),
    );
  }

  void listenerBloc(BuildContext context, BaseState state) {}

  bool buildWhen(BaseState previous, BaseState current) =>
      previous != current && current is ViewState;

  bool listenWhen(BaseState previous, BaseState current) => true;

  Widget buildMobile(BuildContext context, BaseState state);

  Widget buildTablet(BuildContext context, BaseState state) {
    return buildMobile(context, state);
  }

  Widget buildLandscapeMobile(BuildContext context, BaseState state) {
    return buildMobile(context, state);
  }

  Widget buildLandscapeTablet(BuildContext context, BaseState state) {
    return buildTablet(context, state);
  }
}
