import 'package:bloc_base_core/src/presentation/bloc/base_bloc.dart';
import 'package:bloc_base_core/src/presentation/widgets/bloc_widgets/callback.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ViewStateSelector] is responsible for building the UI based on the [ViewState].
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
class ViewStateSelector<T extends ViewState, B extends BlocBase<BaseState>>
    extends BlocSelector<B, BaseState, T> {
  ViewStateSelector(
      {Key? key,
      B? bloc,
      InitialBuilder? onReady,
      LoadingBuilder<T>? onLoading,
      RefreshingBuilder<T>? onRefreshing,
      SuccessBuilder<T>? onSuccess,
      EmptyBuilder? onEmpty,
      ErrorBuilder? onError,
      required ViewStateSelectorCondition<T> selector,
      Widget child = const SizedBox.shrink()})
      : super(
          key: key,
          bloc: bloc,
          selector: selector,
          builder: (context, state) {
            if (state.status == ViewStateEnums.ready) {
              return onReady?.call(context) ?? child;
            } else if (state.status == ViewStateEnums.loading) {
              return onLoading?.call(context, state) ?? child;
            } else if (state.status == ViewStateEnums.refreshing) {
              return onRefreshing?.call(context, state) ?? child;
            } else if (state.status == ViewStateEnums.success) {
              return onSuccess?.call(context, state) ?? child;
            } else if (state.status == ViewStateEnums.empty) {
              return onEmpty?.call(context) ?? child;
            } else if (state.status == ViewStateEnums.error) {
              return onError?.call(context, state.error!) ?? child;
            }
            return child;
          },
        );
}
