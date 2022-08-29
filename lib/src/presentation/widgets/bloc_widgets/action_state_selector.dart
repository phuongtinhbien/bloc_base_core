import 'package:bloc_base_core/src/presentation/bloc/base_bloc.dart';
import 'package:bloc_base_core/src/presentation/widgets/bloc_widgets/callback.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ActionStateSelector] is responsible for building the UI based on the [ViewState].
/// It's a wrapper over the [BlocBuilder] widget so it accepts a [bloc] object and
/// a set of handy callbacks, which corresponds to each possible state:
/// [ready] builder for the the initial state,
/// [loading] builder for the data loading state,
/// [refreshing] builder for the data refreshing state,
/// [success] builder for the data success state,
/// [empty] builder for for no result state,
/// [error] builder function for an error state.
///
/// [T] - the type of elements,
/// [B] - the type of bloc.
class ActionStateSelector<T, B extends BlocBase<BaseState>,
    V extends ActionState> extends BlocSelector<B, BaseState, V> {
  ActionStateSelector(
      {Key? key,
      B? bloc,
      LoadingBuilder? onLoading,
      RefreshingBuilder<T>? onRefreshing,
      SuccessBuilder<T>? onSuccess,
      EmptyBuilder? onEmpty,
      ErrorBuilder? onError,
      required ActionStateSelectorCondition<V> selector,
      Widget child = const SizedBox.shrink()})
      : super(
          key: key,
          bloc: bloc,
          selector: selector,
          builder: (context, state) {
            if (state.status == ActionStateEnums.loading) {
              return onLoading?.call(context, state.data) ?? child;
            } else if (state.status == ActionStateEnums.refreshing) {
              return onRefreshing?.call(context, state.data) ?? child;
            } else if (state.status == ActionStateEnums.success) {
              return onSuccess?.call(context, state.data) ?? child;
            } else if (state.status == ActionStateEnums.empty) {
              return onEmpty?.call(context) ?? child;
            } else if (state.status == ActionStateEnums.error) {
              return onError?.call(context, state.error!) ?? child;
            }
            return child;
          },
        );
}
