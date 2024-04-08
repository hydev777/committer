import 'package:flutter/material.dart';
import 'package:github_repository/github_repository.dart';
import 'package:go_router/go_router.dart';

class CommitTile extends StatelessWidget {
  const CommitTile({
    super.key,
    required this.commit,
  });

  final Commit commit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push('/commit-details', extra: commit);
      },
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(commit.committer.avatarUrl),
          ),
        ),
      ),
      title: Text(
        commit.commitDetails.message,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(commit.commitDetails.committer["name"]),
    );
  }
}
