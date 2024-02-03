import 'package:http/http.dart' as http;

typedef PostCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

typedef GetCall = Future<http.Response> Function(
  Uri url, {
  Map<String, String>? headers,
});

class ApiClient {
  ApiClient({
    required String baseUrl,
    PostCall postCall = http.post,
    GetCall getCall = http.get,
  })  : _base = Uri.parse(baseUrl),
        _post = postCall,
        _get = getCall;

  final Uri _base;
  final PostCall _post;
  final GetCall _get;

  Map<String, String> get _headers => {
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
      };

  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    final response = await _post(
      _base.replace(
        path: path,
        queryParameters: queryParameters,
      ),
      body: body,
      headers: _headers,
    );

    return response;
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await _get(
      _base.replace(
        path: path,
        queryParameters: queryParameters,
      ),
      headers: _headers,
    );

    return response;
  }
}
