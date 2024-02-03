import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

class _MockHttpClient extends Mock {
  Future<http.Response> get(Uri url, {Map<String, String>? headers});
  Future<http.Response> post(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  });
  Future<http.Response> patch(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  });
  Future<http.Response> put(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  });
}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('http://localhost'));
  });
  group(
    'ApiClient',
    () {
      const baseUrl = 'http://baseurl.com';

      late ApiClient subject;
      late _MockHttpClient httpClient;
      final testJson = {'data': 'test'};
      final expectedResponse = http.Response(testJson.toString(), 200);

      setUp(() {
        httpClient = _MockHttpClient();

        when(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => expectedResponse);

        when(
          () => httpClient.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => expectedResponse);

        subject = ApiClient(
          baseUrl: baseUrl,
          getCall: httpClient.get,
          postCall: httpClient.post,
        );
      });

      group('get', () {
        test('return the response', () async {
          final response = await subject.get('/');

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(response.body, equals(expectedResponse.body));
        });

        test('sends the request correctly', () async {
          await subject.get(
            '/path/to/endpoint',
            queryParameters: {
              'param1': 'value1',
              'param2': 'value2',
            },
          );

          verify(
            () => httpClient.get(
              Uri.parse(
                  '$baseUrl/path/to/endpoint?param1=value1&param2=value2'),
              headers: {
                'Connection': 'keep-alive',
                'Accept-Encoding': 'gzip, deflate, br'
              },
            ),
          ).called(1);
        });
      });

      group('post', () {
        test('return the response', () async {
          final response = await subject.post('/');

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(response.body, equals(expectedResponse.body));
        });

        test('sends the request correctly', () async {
          await subject.post(
            '/path/to/endpoint',
            queryParameters: {'param1': 'value1', 'param2': 'value2'},
            body: 'BODY_CONTENT',
          );

          verify(
            () => httpClient.post(
              Uri.parse(
                  '$baseUrl/path/to/endpoint?param1=value1&param2=value2'),
              body: 'BODY_CONTENT',
              headers: {
                'Connection': 'keep-alive',
                'Accept-Encoding': 'gzip, deflate, br'
              },
            ),
          ).called(1);
        });
      });
    },
  );
}
