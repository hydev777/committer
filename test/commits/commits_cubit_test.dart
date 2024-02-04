import 'package:bloc_test/bloc_test.dart';
import 'package:committer/commits/cubit/commits_cubit.dart';
import 'package:github_repository/github_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/scaffolding.dart';

class MockGithubRepository extends Mock implements GithubRepository {}

void main() {
  group('CommitsCubit', () {
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

    late GithubRepository githubRepository;

    setUp(() {
      githubRepository = MockGithubRepository();
    });

    blocTest<CommitsCubit, CommitsState>(
      'emit error when repository throws exception',
      build: () {
        when(
          () => githubRepository.fetchListOfCommitsInRepo(
            'hydev777',
            'committer',
          ),
        ).thenThrow(Exception());

        return CommitsCubit(
          githubRepository: githubRepository,
        );
      },
      act: (cubit) => cubit.onFetchRepositoryCommits('hydev777', 'committer'),
      expect: () => [
        const CommitsState(
          commitStatus: CommitStatus.loading,
        ),
        const CommitsState(
          commitStatus: CommitStatus.error,
        )
      ],
    );

    // blocTest<CommitsCubit, CommitsState>(
    //   "meal list is empty",
    //   build: () {
    //     when(
    //       () => githubRepository.fetchListOfCommitsInRepo(
    //         'hydev777',
    //         'committer',
    //       ),
    //     ).thenAnswer(
    //       (_) async => const [],
    //     );

    //     return CommitsCubit(
    //       githubRepository: githubRepository,
    //     );
    //   },
    //   act: (cubit) => cubit.onFetchRepositoryCommits(
    //     'hydev777',
    //     'committer',
    //   ),
    //   expect: () => [
    //     const CommitsState(
    //       commitStatus: CommitStatus.loading,
    //     ),
    //     const CommitsState(
    //       commitStatus: CommitStatus.empty,
    //     )
    //   ],
    // );

    blocTest<CommitsCubit, CommitsState>(
      "commit list is complete",
      build: () {
        when(
          () => githubRepository.fetchListOfCommitsInRepo(
            'hydev777',
            'committer',
          ),
        ).thenAnswer(
          (_) async => commitsExpected,
        );

        return CommitsCubit(
          githubRepository: githubRepository,
        );
      },
      act: (cubit) => cubit.onFetchRepositoryCommits('hydev777', 'committer'),
      expect: () => [
        const CommitsState(
          commitStatus: CommitStatus.loading,
        ),
        CommitsState(
          commitStatus: CommitStatus.completed,
          commits: commitsExpected,
        )
      ],
    );
  });
}
