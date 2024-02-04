import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_repository/github_repository.dart';

part 'commits_state.dart';

class CommitsCubit extends Cubit<CommitsState> {
  CommitsCubit({
    GithubRepository? githubRepository,
  })  : _githubRepository = githubRepository,
        super(const CommitsState());

  final GithubRepository? _githubRepository;

  Future<void> onFetchRepositoryCommits(String owner, String repository) async {
    emit(
      state.copyWith(
        commitStatus: CommitStatus.loading,
      ),
    );

    try {
      final response =
          await _githubRepository!.fetchListOfCommitsInRepo(owner, repository);

      emit(
        state.copyWith(
          commits: response,
          commitStatus: CommitStatus.completed,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          commitStatus: CommitStatus.error,
        ),
      );
    }
  }
}
