import 'package:bloc_base_core/src/presentation/bloc/base_bloc.dart';
import 'package:bloc_base_core/src/presentation/widgets/bloc_widgets/callback.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ViewStateListener] is responsible for performing an action based on the
/// [ViewState].
/// It should be used for functionality that needs to occur only in response to
/// a [state] change such as navigation, showing a [SnackBar], showing
/// a [Dialog], etc.
/// [ViewStateListener] is a wrapper over the [BlocListener] widget so it accepts
/// a [bloc] object as well as a [child] widget and a set of handy callbacks
/// corresponding to a given state:
/// [onLoading] callback for the data loading state,
/// [onRefreshing] callback for the data refreshing state,
/// [onSuccess] callback for the data success state,
/// [onEmpty] callback for for no result state,
/// [onError] callback function for an error state.
///
/// [T] - the type of elements,
/// [B] - the type of bloc.
class ViewStateListener<T, B extends BlocBase<ViewState>>
    extends BlocListener<B, ViewState> {
  ViewStateListener({
    Key? key,
    B? bloc,
    ViewStateListenerCondition? listenWhen,
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
            if (state.status == ViewStateEnums.loading) {
              onLoading?.call(context);
            } else if (state.status == ViewStateEnums.refreshing) {
              onRefreshing?.call(context, state.data);
            } else if (state.status == ViewStateEnums.success) {
              onSuccess?.call(context, state.data);
            } else if (state.status == ViewStateEnums.empty) {
              onEmpty?.call(context);
            } else if (state.status == ViewStateEnums.error) {
              onError?.call(context, state.error!);
            }
          },
        );
}
