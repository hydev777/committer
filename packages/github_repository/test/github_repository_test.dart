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
    });

    group('list of commits in repo:', () {
      setUp(() {
        when(() => subject2.fetchListOfCommitsInRepo('hydev777', 'committer'))
            .thenAnswer(
          (_) async => http.Response(
            commitsExpected
                .map(
                  (commit) => commit,
                )
                .toList(),
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
