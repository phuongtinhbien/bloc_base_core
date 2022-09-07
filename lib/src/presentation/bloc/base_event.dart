part of 'base_bloc.dart';

/// `BaseEvent` is an abstract class that extends `Equatable` and has a `props`
/// property that is a list of objects
abstract class BaseEvent extends Equatable {
  @override
  final List props;
  const BaseEvent([this.props = const []]);

  @override
  String toString() => '$runtimeType';
}

class InitEvent extends BaseEvent {}
