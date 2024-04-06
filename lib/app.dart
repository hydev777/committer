import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repository/github_repository.dart';

import 'commits/cubit/commits_cubit.dart';
import 'router.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required GithubRepository githubRepository,
  }) : _githubRepository = githubRepository;

  final GithubRepository _githubRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CommitsCubit(
            githubRepository: _githubRepository,
          ),
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}
