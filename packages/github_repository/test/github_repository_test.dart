import 'dart:convert';

import 'package:github_api/github_api.dart';
import 'package:github_repository/github_repository.dart';
import 'package:github_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockGithubApi extends Mock implements GithubApi {}

void main() {
  group('Github repository', () {
    late GithubApi githubApi;
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
        sha: 'test',
        htmlUrl: 'test',
        nodeId: 'test',
      ),
    );

    setUp(() {
      githubApi = _MockGithubApi();

      subject2 = GithubRepository(
        githubApi: githubApi,
      );
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
