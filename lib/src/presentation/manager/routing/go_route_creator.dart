import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';


/// A function that returns a widget.
typedef CreatorBuilder = Widget Function(BuildContext context, Object);

/// Used to create a `Page` from a `GoRoute`.
typedef CreatorPageBuilder = Page<void> Function(BuildContext context, Object);

/// `CreatorRedirect` is used to redirect to another route.
typedef CreatorRedirect = String? Function(Object data);

abstract class GoRouteCreator<T extends AppGoRouteData> {
  /// A function that returns a widget.
  final CreatorBuilder? builder;

  /// A function that returns a Page.
  final CreatorPageBuilder? pageBuilder;

  /// Used to redirect to another route.
  final CreatorRedirect? redirect;

  const GoRouteCreator({this.builder, this.pageBuilder, this.redirect});


  /// A function that returns the location of the route.
  String $location(T data);

  /// A factory method that converts a `GoRouterState` into a `AppGoRouteData`.
  T $fromState(GoRouterState state);

  /// A factory method that returns a `GoRoute` with the `factory` property set to
  /// `$fromState`.
  GoRoute $route({required String path, List<GoRoute> routes = const []}) {
    return GoRouteData.$route(
      path: path,
      factory: $fromState,
      routes: routes,
    );
  }
}

abstract class AppGoRouteData extends GoRouteData {
  /// Used to identify the page in the `PageStorage`.
  final ValueKey<String>? pageKey;

  /// A factory method that returns a `GoRoute` with the `factory` property set to
  /// `$fromState`.
  final GoRouteCreator creator;

  AppGoRouteData(this.creator, {this.pageKey});

  /// Used to identify the route.
  String get location => creator.$location(this);

  /// Used to pass data to the `GoRouteCreator`.
  Object? get $extra => null;

  @override
  /// A function that returns a widget.
  Widget build(BuildContext context, GoRouterState state) {
    return creator.builder?.call(context, this) ?? super.build(context, state);
  }

  @override
  /// Used to create a `Page` from a `GoRoute`.
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return creator.pageBuilder?.call(context, this) ?? super.buildPage(context, state);
  }

  // @override
  // /// Used to redirect to another route.
  // FutureOr<String?> redirect() {
  //   return  null;
  // }

  /// `go` is a method that is used to navigate to a route.
  void go(BuildContext context) => context.go(location, extra: this);

  /// Pushing a new route onto the stack.
  Future<T?> push<T extends Object?>(BuildContext context) => context.push<T>(location, extra: this);

  /// Replacing the current route with the new route.
  void replace(BuildContext context) => context.replace(location, extra: this);
}

/// `NoOpPage` is a `Page` that is used when the `GoRouteCreator` does not have a
/// `pageBuilder`.
class NoOpPage extends Page<void> {
  const NoOpPage();

  @override
  Route<void> createRoute(BuildContext context) =>
      throw UnsupportedError('Should never be called');
}
