// import 'dart:convert';

// import 'package:github_api/github_api.dart';
// import 'package:http/http.dart' as http;
// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';

// class MockHttpClient extends Mock implements http.Client {}

// void main() {
//   late Uri commitsUrl;

//   group("Commits", () {
//     late http.Client httpClient;
//     late GithubApi subject;
//     final testJson = {'data': 'test'};
//     final expectedResponse = http.Response(json.encode(testJson), 200);

//     setUp(() {
//       httpClient = MockHttpClient();
//       subject = GithubApi(
//         baseUrl: "https://api.github.com",
//         httpClient: httpClient,
//       );
//       commitsUrl = Uri.https(
//         "api.github.com",
//         "/repos/hydev777/committer/commits",
//       );
//     });

//     group("fetch the commits of repo", () {
//       setUp(() {
//         when(() => httpClient.get(commitsUrl)).thenAnswer(
//           (_) async => expectedResponse,
//         );
//       });

//       test("throws HttpException when http client throws exception", () {
//         when(() => httpClient.get(commitsUrl)).thenThrow(Exception());

//         expect(
//           () => subject.fetchCommitsOfRepo('test', 'test'),
//           throwsA(isA<HttpException>()),
//         );
//       });

//       test(
//         'throws HttpRequestFailure when response status code is not 200',
//         () {
//           when(() => httpClient.get(commitsUrl)).thenAnswer(
//             (_) async => http.Response('', 400),
//           );

//           expect(
//             () => subject.fetchCommitsOfRepo('hydev777', 'committer'),
//             throwsA(
//               isA<HttpRequestFailure>()
//                   .having((error) => error.statusCode, 'statusCode', 400),
//             ),
//           );
//         },
//       );

//       test("sends the request correctly", () async {
//         await subject.fetchCommitsOfRepo('hydev777', 'committer');

//         verify(
//           () => httpClient.get(commitsUrl),
//         ).called(1);
//       });

//       test("returns the response", () async {
//         final response =
//             await subject.fetchCommitsOfRepo('hydev777', 'committer');

//         expect(response.statusCode, expectedResponse.statusCode);
//         expect(response.body, expectedResponse.body);
//       });
//     });
//   });
// }
