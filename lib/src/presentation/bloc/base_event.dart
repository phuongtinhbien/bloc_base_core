part of 'base_bloc.dart';

abstract class BaseEvent extends Equatable {
  @override
  final List props;
  const BaseEvent([this.props = const []]);

  @override
  String toString() => '$runtimeType';
}

class InitEvent extends BaseEvent {}
