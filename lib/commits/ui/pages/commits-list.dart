import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/commits_cubit.dart';

class CommitList extends StatefulWidget {
  const CommitList({super.key});

  @override
  State<CommitList> createState() => _CommitListState();
}

class _CommitListState extends State<CommitList> {
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
                  return Text(state.commits![index].commitDetails!.message!);
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
