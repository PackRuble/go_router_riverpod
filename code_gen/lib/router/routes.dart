import 'dart:async';

import 'package:code_gen/state/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: SplashRoute.path)
class SplashRoute extends GoRouteData {
  const SplashRoute();
  static const path = '/splash';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashPage();
  }
}

@TypedGoRoute<HomeRoute>(path: HomeRoute.path, routes: [
  TypedGoRoute<AdminRoute>(path: AdminRoute.path),
  TypedGoRoute<UserRoute>(path: UserRoute.path),
  TypedGoRoute<GuestRoute>(path: GuestRoute.path),
])
class HomeRoute extends GoRouteData {
  const HomeRoute();
  static const path = '/home';

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    if (state.location == HomeRoute.path) return null;

    final roleListener = ProviderScope.containerOf(context).listen(
      permissionsProvider.select((value) => value.valueOrNull),
      (previous, next) {},
    );

    final userRole = roleListener.read();
    final redirectTo = userRole?.maybeMap(
      admin: (_) => null,
      user: (_) {
        if (state.location == AdminRoute.path) return HomeRoute.path;
        return null;
      },
      orElse: () {
        if (state.location != HomeRoute.path) return HomeRoute.path;
        return null;
      },
    );

    roleListener.close();
    return redirectTo;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

@TypedGoRoute<LoginRoute>(path: LoginRoute.path)
class LoginRoute extends GoRouteData {
  const LoginRoute();
  static const path = '/login';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

class AdminRoute extends GoRouteData {
  const AdminRoute();
  static const path = 'admin';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AdminPage();
  }
}

class UserRoute extends GoRouteData {
  const UserRoute();
  static const path = 'user';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserPage();
  }
}

class GuestRoute extends GoRouteData {
  const GuestRoute();
  static const path = 'guest';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GuestPage();
  }
}
