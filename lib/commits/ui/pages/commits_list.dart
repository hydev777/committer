import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit/commits_cubit.dart';

class CommitListView extends StatefulWidget {
  const CommitListView({super.key});

  @override
  State<CommitListView> createState() => _CommitListState();
}

class _CommitListState extends State<CommitListView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<CommitsCubit>()
          .onFetchRepositoryCommits('hydev777', 'committer');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commits'),
        actions: [
          IconButton(
            onPressed: () async {
              await context
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
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.commits!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            context.push('/commit-details',
                                extra: state.commits![index]);
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(state
                                    .commits![index].committer!.avatarUrl!),
                              ),
                            ),
                          ),
                          title: Text(
                            state.commits![index].commitDetails!.message!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(state.commits![index].commitDetails!
                              .committer!["name"]),
                        );
                      },
                    ),
                  ),
                ],
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
