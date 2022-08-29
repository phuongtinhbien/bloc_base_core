// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_bloc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ViewStateCWProxy<T> {
  ViewState<T> data(T data);

  ViewState<T> error(BaseFailure? error);

  ViewState<T> status(ViewStateEnums status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ViewState<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ViewState<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  ViewState<T> call({
    T? data,
    BaseFailure? error,
    ViewStateEnums? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfViewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfViewState.copyWith.fieldName(...)`
class _$ViewStateCWProxyImpl<T> implements _$ViewStateCWProxy<T> {
  final ViewState<T> _value;

  const _$ViewStateCWProxyImpl(this._value);

  @override
  ViewState<T> data(T data) => this(data: data);

  @override
  ViewState<T> error(BaseFailure? error) => this(error: error);

  @override
  ViewState<T> status(ViewStateEnums status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ViewState<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ViewState<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  ViewState<T> call({
    Object? data = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return ViewState<T>(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as T,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as BaseFailure?,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ViewStateEnums,
    );
  }
}

extension $ViewStateCopyWith<T> on ViewState<T> {
  /// Returns a callable class that can be used as follows: `instanceOfViewState.copyWith(...)` or like so:`instanceOfViewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ViewStateCWProxy<T> get copyWith => _$ViewStateCWProxyImpl<T>(this);
}
