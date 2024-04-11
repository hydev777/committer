import 'package:flutter/material.dart';
import 'package:github_repository/github_repository.dart';
import 'package:go_router/go_router.dart';

import 'commits/pages/commit_details.dart';
import 'commits/pages/commits_list_page.dart';

final _rootKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
  routes: [
    GoRoute(
      path: '/commits-list',
      builder: (context, state) => const CommitListPage(),
    ),
    GoRoute(
      path: '/commit-details',
      builder: (context, state) => CommitDetailsView(
        url: (state.extra! as Commit).htmlUrl,
      ),
    ),
  ],
  initialLocation: "/commits-list",
);
