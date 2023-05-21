import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/reposition/data/repositories/reposition_repository.dart';
import 'package:nexus_estoque/features/reposition/pages/reposition_page/cubit/reposition_cubit.dart';

import 'widgets/reposition_card_widget.dart';

class RepositionPage extends ConsumerStatefulWidget {
  const RepositionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RepositionPageState();
}

class _RepositionPageState extends ConsumerState<RepositionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reposição')),
      body: BlocProvider(
        create: (context) =>
            RepositionCubit(repository: ref.read(repositionRepositoryProvider)),
        child: BlocBuilder<RepositionCubit, RepositionState>(
          builder: (context, state) {
            if (state is RepositionLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is RepositionError) {
              return Center(
                child: Text(state.error.error),
              );
            }

            if (state is RepositionLoaded) {
              final repositions = state.repositions;
              return ListView.builder(
                itemCount: repositions.length,
                itemBuilder: (context, index) {
                  return RepositionCard(reposition: repositions[index]);
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
