import 'dart:convert';

import 'package:github_repository/github_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late Uri commitsUrl;
  group('Github repository', () {
    late http.Client httpClient;
    late GithubRepository subject2;

    final commitsExpected = List.generate(
      3,
      (index) => Commit(
        committer: Committer(
          id: index,
          profileUrl: 'test',
          avatarUrl: 'test',
          login: 'test',
        ),
        commitDetails: CommitDetails(
          message: "test",
          commentCount: 0,
          author: {"test": "test"},
          committer: {"test": "test"},
        ),
        sha: 'test',
        htmlUrl: 'test',
        nodeId: 'test',
      ),
    );

    setUp(() {
      httpClient = MockHttpClient();

      subject2 = GithubRepository(
        baseUrl: "https://api.github.com",
        httpClient: httpClient,
      );

      commitsUrl = Uri.https(
        "api.github.com",
        "/repos/hydev777/committer/commits",
      );
    });

    group("fetch the commits of repo", () {
      setUp(() {
        when(() => httpClient.get(commitsUrl)).thenAnswer(
          (_) async => expectedResponse,
        );
      });

      test("throws HttpException when http client throws exception", () {
        when(() => httpClient.get(commitsUrl)).thenThrow(Exception());

        expect(
          () => subject.fetchCommitsOfRepo('test', 'test'),
          throwsA(isA<HttpException>()),
        );
      });

      test(
        'throws HttpRequestFailure when response status code is not 200',
        () {
          when(() => httpClient.get(commitsUrl)).thenAnswer(
            (_) async => http.Response('', 400),
          );

          expect(
            () => subject.fetchCommitsOfRepo('hydev777', 'committer'),
            throwsA(
              isA<HttpRequestFailure>()
                  .having((error) => error.statusCode, 'statusCode', 400),
            ),
          );
        },
      );

      test("sends the request correctly", () async {
        await subject.fetchCommitsOfRepo('hydev777', 'committer');

        verify(
          () => httpClient.get(commitsUrl),
        ).called(1);
      });

      test("returns the response", () async {
        final response =
            await subject.fetchCommitsOfRepo('hydev777', 'committer');

        expect(response.statusCode, expectedResponse.statusCode);
        expect(response.body, expectedResponse.body);
      });
    });

    group('list of commits in repo:', () {
      setUp(() {
        when(() => githubApi.fetchCommitsOfRepo('hydev777', 'committer'))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(
              commitsExpected
                  .map(
                    (commit) => commit.toJson(),
                  )
                  .toList(),
            ),
            200,
          ),
        );
      });

      test("fetch commits", () async {
        final listOfCommits =
            await subject2.fetchListOfCommitsInRepo('hydev777', 'committer');

        expect(listOfCommits, commitsExpected);
      });
    });
  });
}
