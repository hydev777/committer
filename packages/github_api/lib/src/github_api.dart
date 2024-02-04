import 'package:http/http.dart' as http;

class HttpException implements Exception {}

class HttpRequestFailure implements Exception {
  const HttpRequestFailure(this.statusCode);

  final int statusCode;
}

class GithubApi {
  GithubApi({
    required String baseUrl,
    required http.Client httpClient,
  })  : _baseUrl = Uri.parse(baseUrl),
        _httpClient = httpClient;

  final http.Client _httpClient;
  final Uri? _baseUrl;

  Future<http.Response> fetchCommitsOfRepo(
      String owner, String repository) async {
    http.Response? response;
    Uri commitsUrl = _baseUrl!.replace(
      path: "/repos/$owner/$repository/commits",
    );

    try {
      response = await _httpClient.get(commitsUrl);
    } catch (err) {
      throw HttpException();
    }

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    return response;
  }
}
