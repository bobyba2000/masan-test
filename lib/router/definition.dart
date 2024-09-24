import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_test/ui/admin/page.dart';

import '../main.dart';
import 'name.dart';

final rootKey = GlobalKey<NavigatorState>();
final mainKey = GlobalKey<NavigatorState>();

class RouterDefinition {
  static final router = GoRouter(
    initialLocation: RouteName.landing,
    navigatorKey: rootKey,
    routes: [
      GoRoute(
        path: RouteName.landing,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteName.admin,
        builder: (context, state) => const AdminPage(),
      ),
    ],
  );
}
