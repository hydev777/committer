import 'package:flutter/material.dart';
import 'package:github_api/github_api.dart';
import 'package:github_repository/github_repository.dart';
import 'package:http/http.dart' as http;

import 'app/app.dart';

void main() {
  final GithubRepository githubRepository = GithubRepository(
    githubApi: GithubApi(
      baseUrl: 'https://api.github.com',
      httpClient: http.Client(),
    ),
  );

  runApp(
    App(
      githubRepository: githubRepository,
    ),
  );
}
