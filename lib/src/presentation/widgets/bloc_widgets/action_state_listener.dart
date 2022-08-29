import 'package:bloc_base_core/src/presentation/bloc/base_bloc.dart';
import 'package:bloc_base_core/src/presentation/widgets/bloc_widgets/callback.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ActionStateListener] is responsible for performing an action based on the
/// [ActionState].
/// It should be used for functionality that needs to occur only in response to
/// a [state] change such as navigation, showing a [SnackBar], showing
/// a [Dialog], etc.
/// [ActionStateListener] is a wrapper over the [BlocListener] widget so it accepts
/// a [bloc] object as well as a [child] widget and a set of handy callbacks
/// corresponding to a given state:
/// [loading] callback for the data loading state,
/// [refreshing] callback for the data refreshing state,
/// [success] callback for the data success state,
/// [empty] callback for for no result state,
/// [error] callback function for an error state.
///
/// [T] - the type of elements,
/// [B] - the type of bloc.
class ActionStateListener<T, B extends BlocBase<BaseState>>
    extends BlocListener<B, BaseState> {
  ActionStateListener({
    Key? key,
    B? bloc,
    ActionStateListenerCondition? listenWhen,
    LoadingCallback? onLoading,
    RefreshingCallback<T>? onRefreshing,
    SuccessCallback<T>? onSuccess,
    EmptyCallback? onEmpty,
    ErrorCallback? onError,
    Widget? child,
  }) : super(
          key: key,
          bloc: bloc,
          listenWhen: listenWhen,
          child: child,
          listener: (context, state) {
            if (state is ActionState) {
              if (state.status == ActionStateEnums.loading) {
                onLoading?.call(context);
              } else if (state.status == ActionStateEnums.refreshing) {
                onRefreshing?.call(context, state.data);
              } else if (state.status == ActionStateEnums.success) {
                onSuccess?.call(context, state.data);
              } else if (state.status == ActionStateEnums.empty) {
                onEmpty?.call(context);
              } else if (state.status == ActionStateEnums.error) {
                onError?.call(context, state.error!);
              }
            }
          },
        );
}
