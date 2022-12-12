import 'package:bloc_base_core/src/data/base_failure.dart';
import 'package:bloc_base_core/src/presentation/bloc/base_bloc.dart';
import 'package:flutter/widgets.dart';

/// Callback function for the data loading state.
typedef LoadingCallback = void Function(BuildContext context);

/// Callback function for a success. The data was fetched and nonnull
/// element was returned.
typedef SuccessCallback<T> = void Function(BuildContext context, T data);

/// Callback function for the data refreshing state
typedef RefreshingCallback<T> = void Function(BuildContext context, T data);

/// Callback function for no result. The data was fetched
/// successfully, but a null element was returned.
typedef EmptyCallback = void Function(BuildContext context);

/// Defining a function type.
typedef ReadyCallback = void Function(BuildContext context);

/// Callback function for an error. It contains an [error] that has caused
/// which may allow a view to react differently on different errors.
typedef ErrorCallback = void Function(BuildContext context, BaseFailure error);

/// Signature for the [listenWhen] function which takes the previous [ViewState]
/// and the current [ViewState] and is responsible for returning a [bool] which
/// determines whether or not to call the [listener] function.
typedef ViewStateListenerCondition = bool Function(
  BaseState previous,
  BaseState current,
);

/// Builder function for the the initial state.
typedef InitialBuilder = Widget Function(BuildContext context);

/// Builder function for the data loading state.
typedef LoadingBuilder<T> = Widget Function(BuildContext context, T? data);

/// Builder function for a success state. The data was fetched and nonnull
/// element was returned.
typedef SuccessBuilder<T> = Widget Function(BuildContext context, T data);

/// Builder function for the data refreshing state. Can only occur after
/// [SuccessBuilder].
typedef RefreshingBuilder<T> = Widget Function(BuildContext context, T? data);

/// Builder function for no result. The data was fetched
/// successfully, but a null element was returned.
typedef EmptyBuilder = Widget Function(BuildContext context);


/// Builder function for an error. It contains an [error] that has caused
/// which may allow a view to react differently on different errors.
typedef ErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
);

/// Signature for the [buildWhen] function which takes the previous [ViewState]
/// and the current [ViewState] and returns a [bool] which determines whether
/// to rebuild the `view` with the current `state`.
typedef ViewStateBuilderCondition = bool Function(
  BaseState previous,
  BaseState current,
);

/// Signature for the [listenWhen] function which takes the previous [ActionState]
/// and the current [ActionState] and is responsible for returning a [bool] which
/// determines whether or not to call the [listener] function.
typedef ActionStateListenerCondition = bool Function(
  BaseState previous,
  BaseState current,
);

typedef ViewStateSelectorCondition<V extends ViewState> = V Function(
    BaseState state);
typedef ActionStateSelectorCondition<V extends ActionState> = V Function(
    BaseState state);
