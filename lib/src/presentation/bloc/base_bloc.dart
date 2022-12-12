import 'package:bloc_base_core/src/data/base_failure.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'base_bloc.g.dart';
part 'base_event.dart';
part 'base_state.dart';

/// > BaseBloc is an abstract class that extends Bloc and takes two generic types: T
/// extends BaseEvent and BaseState
abstract class BaseBloc<T extends BaseEvent, BaseState>
    extends Bloc<T, BaseState> with WidgetsBindingObserver, RouteAware {
  late bool _isMounted;


  @mustCallSuper
  BaseBloc(BaseState initialState) : super(initialState) {
    _isMounted = true;
    listenEvent();
    WidgetsBinding.instance.addObserver(this);
  }

  @visibleForOverriding
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isMounted) {
      switch (state) {
        case AppLifecycleState.inactive:
          onInActive();
          break;
        case AppLifecycleState.paused:
          onPaused();
          break;
        case AppLifecycleState.resumed:
          onResumed();
          break;
        case AppLifecycleState.detached:
          onDetached();
          break;
      }
    }
  }

  @disposeMethod
  @override
  Future<void> close() {
    _isMounted = false;
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @visibleForOverriding
  void listenEvent();

  @visibleForOverriding
  void onInActive() {}

  @visibleForOverriding
  void onPaused() {}

  @visibleForOverriding
  void onResumed() {}

  @visibleForOverriding
  void onDetached() {}
}
