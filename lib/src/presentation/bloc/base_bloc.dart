import 'package:bloc_base_core/src/data/base_failure.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'base_bloc.g.dart';
part 'base_event.dart';
part 'base_state.dart';

abstract class BaseBloc<T extends BaseEvent, BaseState>
    extends Bloc<T, BaseState> {
  BaseBloc(BaseState initialState) : super(initialState) {
    listenEvent();
  }
  void listenEvent();
}
