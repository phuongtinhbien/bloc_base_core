import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

/// A class that is used to create a router.
abstract class AppRoute {
  /// A class that contains all the routes for the app.
  final AppRoutesList routeList;
  /// Used to notify the app that a route has been changed.
  final AppRouteRefreshListenable? refreshListenable;
  /// `GoRouter` is a wrapper around `Navigator` that is used to navigate between
  /// pages.
  late final GoRouter router;

  AppRoute(this.routeList, {this.refreshListenable}){
    router = GoRouter(
      initialLocation: '/',
      urlPathStrategy: UrlPathStrategy.path,
      refreshListenable: refreshListenable,
      routes: routeList.$routes,
      debugLogDiagnostics: true,
      observers: observers,
      errorPageBuilder: errorPageBuilder,
      redirect: redirect,
    );
  }

  /// Used to listen to the route changes.
  List<NavigatorObserver> get observers;


  /// A function that is called when a route is not found.
  Page<void> errorPageBuilder(BuildContext context, GoRouterState state);

  /// Used to redirect the user to a different route.
  String? redirect(GoRouterState state) => null;

  /// `dispose` is called when the object is removed from the tree, and it's used to
  /// free up resources
  @disposeMethod
  void dispose() {
    refreshListenable?.dispose();
    router.dispose();
  }
}




/// A class that is used to notify the app that a route has been changed.
abstract class AppRouteRefreshListenable extends ChangeNotifier {

  AppRouteRefreshListenable();
}

/// A class that contains all the routes for the app.
abstract class AppRoutesList {
  /// A getter that returns a list of routes.
  ///List<GoRoute> get $routes => [
  ///  splash.$route(path: SplashRoute.path),
  ///];
  List<GoRoute> get $routes;

  /// A route creator.
  /// final splash = SplashRouteCreator(builder: (_, data) => const SplashScreen());


}

/// It's a custom page that is used to create a slide up transition.
class SlideUpPage<T> extends CustomTransitionPage<T> {
  SlideUpPage({
    required Widget child,
    super.transitionDuration,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
            child: child,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0, 1);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            });
}

/// It's a custom page that is used to fade in and out when navigating between
/// pages.
class FadePage<T> extends CustomTransitionPage<T> {
  FadePage({
    required Widget child,
    super.transitionDuration,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
            child: child,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            });
}
