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
  /// Getting the instance of the BLoC.
  T get bloc => GetIt.I<T>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initBloc();
    });
  }

  /// > It resets the lazy singleton of type T
  @override
  void dispose() {
    GetIt.I.resetLazySingleton<T>();
    super.dispose();
  }

  /// A method that is called in the `initState` method.
  void initBloc();

  /// A getter that returns the current theme.
  AppTheme get currentTheme => GetIt.I<ThemeManagerCubit>().currentTheme;

  /// A getter that is used to determine whether the state of the widget should be
  /// kept alive.
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
          return ResponsiveBuilder(builder: (_, sizingInformation) {
            if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
              return OrientationBuilder(
                  builder: (orientationContext, orientation) {
                if (orientation == Orientation.landscape) {
                  return buildLandscapeTablet(orientationContext, state);
                }
                return buildTablet(orientationContext, state);
              });
            }

            return OrientationBuilder(
                builder: (orientationContext, orientation) {
              if (orientation == Orientation.landscape) {
                return buildLandscapeMobile(orientationContext, state);
              }
              return buildMobile(orientationContext, state);
            });
          });
        },
      ),
    );
  }


  /// This method is called when the state of the BLoC changes.
  /// `listenerBloc` is a function that takes a `BuildContext` and a `BaseState` as
  /// parameters for override
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that is listening to the
  /// bloc.
  ///   state (BaseState): The state of the bloc.
  void listenerBloc(BuildContext context, BaseState state) {}

  /// If the previous state is not the same as the current state, and the current
  /// state is a ViewState, then return true
  ///
  /// Args:
  ///   previous (BaseState): The previous state of the bloc.
  ///   current (BaseState): The current state of the BLoC.
  bool buildWhen(BaseState previous, BaseState current) =>
      previous != current && current is ViewState;

  /// Listen when the previous state is not the same as the current state.
  ///
  /// Args:
  ///   previous (BaseState): The previous state of the app.
  ///   current (BaseState): The current state of the app.
  bool listenWhen(BaseState previous, BaseState current) => true;

  /// This is a method that is called when the device is a mobile device.
  Widget buildMobile(BuildContext context, BaseState state);

  /// If the device is a tablet, return the mobile version of the widget.
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget.
  ///   state (BaseState): The state of the app.
  ///
  /// Returns:
  ///   A widget.
  Widget buildTablet(BuildContext context, BaseState state) {
    return buildMobile(context, state);
  }

  /// If the device is in landscape mode, return the mobile layout.
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget.
  ///   state (BaseState): The state of the app.
  ///
  /// Returns:
  ///   A widget.
  Widget buildLandscapeMobile(BuildContext context, BaseState state) {
    return buildMobile(context, state);
  }

  /// If the device is a tablet, and the orientation is landscape, then build the
  /// tablet layout.
  ///
  /// Args:
  ///   context (BuildContext): The BuildContext of the widget.
  ///   state (BaseState): The state of the app.
  ///
  /// Returns:
  ///   A widget that is a Scaffold with a body that is a ListView with a Column
  /// that has a Text widget and a ListView widget.
  Widget buildLandscapeTablet(BuildContext context, BaseState state) {
    return buildTablet(context, state);
  }
}
