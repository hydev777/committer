import 'dart:convert';

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
    required String baseUrl,
    required http.Client httpClient,
  })  : _baseUrl = Uri.parse(baseUrl),
        _httpClient = httpClient;

  final Uri? _baseUrl;
  final http.Client _httpClient;

  Future<List<Commit>> fetchListOfCommitsInRepo(
    String owner,
    String repository,
  ) async {
    http.Response response;
    Uri commitsUrl = _baseUrl!.replace(
      path: "/repos/$owner/$repository/commits",
    );
    try {
      response = await _httpClient.get(commitsUrl);
    } catch (err) {
      print(err);
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
    } catch (err) {
      throw JsonDecodeException();
    }
  }
}
