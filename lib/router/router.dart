import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../commits/ui/pages/commit-details.dart';
import '../commits/ui/pages/commits-list.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _nestedKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
  routes: [
    ShellRoute(
      navigatorKey: _nestedKey,
      pageBuilder: (context, state, child) {
        return MaterialPage(
          child: HeroControllerScope(
            controller: MaterialApp.createMaterialHeroController(),
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/commits-list',
          builder: (context, state) => const CommitList(),
        ),
        GoRoute(
          path: '/commit-details',
          builder: (context, state) => const CommitDetails(),
        ),
      ],
    ),
  ],
  initialLocation: "/commits-list",
);
