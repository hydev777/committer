import 'dart:convert';

import 'package:github_api/github_api.dart';
import 'package:http/http.dart' as http;

import 'models/commit.dart';

class HttpException implements Exception {}

class JsonDecodeException implements Exception {}

class HttpRequestFailure implements Exception {
  const HttpRequestFailure(this.statusCode);

  final int statusCode;
}

class GithubRepository {
  GithubRepository({
    required GithubApi githubApi,
  }) : _githubApi = githubApi;

  final GithubApi _githubApi;

  Future<List<Commit>> fetchListOfCommitsInRepo(
      String owner, String repository) async {
    http.Response response;
    try {
      response = await _githubApi.fetchCommitsOfRepo(owner, repository);
    } catch (err, stack) {
      print("=======> $err");
      print("++++++++++++++++++>>> $stack");
      throw HttpException();
    }

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    try {
      final body = json.decode(response.body) as List<dynamic>;

      return (body)
          .map(
            (commit) => Commit.fromJson(commit),
          )
          .toList();
    } catch (err, stack) {
      print("==================== $err");
      print("++++++++++++++++++>>> $stack");
      throw JsonDecodeException();
    }
  }
}
