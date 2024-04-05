import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../cubit/commits_cubit.dart';
import '../widgets/commit_tile.dart';

class CommitListView extends StatefulWidget {
  const CommitListView({super.key});

  @override
  State<CommitListView> createState() => _CommitListState();
}

class _CommitListState extends State<CommitListView> {
  @override
  void initState() {
    super.initState();

    context
        .read<CommitsCubit>()
        .onFetchRepositoryCommits('hydev777', 'committer');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commits'),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<CommitsCubit>()
                  .onFetchRepositoryCommits('hydev777', 'committer');
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<CommitsCubit, CommitsState>(
          builder: (context, state) {
            if (state.commitStatus == CommitStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.commitStatus == CommitStatus.completed) {
              return ListView.builder(
                itemCount: state.commits!.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: CommitTile(
                          commit: state.commits![index],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            if (state.commitStatus == CommitStatus.error) {
              return const Center(
                child: Text("An http error has ocurred"),
              );
            }

            return const Center(
              child: Text("Unexpected error"),
            );
          },
        ),
      ),
    );
  }
}
