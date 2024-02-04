part of 'commits_cubit.dart';

enum CommitStatus { loading, completed, error, empty }

class CommitsState extends Equatable {
  const CommitsState({
    this.commitStatus,
    this.commits = const [],
  });

  final CommitStatus? commitStatus;
  final List<Commit>? commits;

  CommitsState copyWith({
    CommitStatus? commitStatus,
    List<Commit>? commits,
  }) {
    return CommitsState(
      commitStatus: commitStatus ?? this.commitStatus,
      commits: commits ?? this.commits,
    );
  }

  @override
  List<Object?> get props => [
        commitStatus,
        commits,
      ];
}
