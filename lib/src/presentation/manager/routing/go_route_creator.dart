import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

typedef CreatorBuilder = Widget Function(BuildContext context, Object);

typedef CreatorPageBuilder = Page<void> Function(BuildContext context, Object);

typedef CreatorRedirect = String? Function(Object data);

abstract class GoRouteCreator<T extends AppGoRouteData> {
  final CreatorBuilder? builder;

  final CreatorPageBuilder? pageBuilder;

  final CreatorRedirect? redirect;

  const GoRouteCreator({this.builder, this.pageBuilder, this.redirect});

  String $location(T data);

  T $fromState(GoRouterState state);

  GoRoute $route({required String path, List<GoRoute> routes = const []}) {
    return GoRouteData.$route(
      path: path,
      factory: $fromState,
      routes: routes,
    );
  }
}

abstract class AppGoRouteData extends GoRouteData {
  final ValueKey<String>? pageKey;

  final GoRouteCreator creator;

  AppGoRouteData(this.creator, {this.pageKey});

  String get location => creator.$location(this);

  Object? get $extra => null;

  @override
  Widget build(BuildContext context) {
    return creator.builder?.call(context, this) ?? super.build(context);
  }

  @override
  Page<void> buildPage(BuildContext context) {
    return creator.pageBuilder?.call(context, this) ?? super.buildPage(context);
  }

  @override
  String? redirect() {
    return creator.redirect?.call(this) ?? super.redirect();
  }

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void replace(BuildContext context) => context.replace(location, extra: this);
}

class NoOpPage extends Page<void> {
  const NoOpPage();

  @override
  Route<void> createRoute(BuildContext context) =>
      throw UnsupportedError('Should never be called');
}
