import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/phrases_cubit.dart';
import '../bloc/phrases_state.dart';
import '../../../../shared/widgets/phrase_card/phrase_card.dart';
import '../widgets/category_chips.dart';

class PhrasesPage extends StatelessWidget {
  const PhrasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhrasesCubit, PhrasesState>(
      builder: (context, state) {
        if (state is PhrasesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PhrasesError) {
          return Center(child: Text('Erro: ${state.message}'));
        }
        if (state is PhrasesLoaded) {
          final cats = state.categories;
          final selected = state.selectedCategory;
          final filtered = selected == 'Todas'
              ? state.all
              : state.all.where((p) => p.category == selected).toList();
          return Column(
            children: [
              // Category chips widget
              CategoryChips(
                categories: cats,
                selected: selected,
                onSelected: (cat) => context.read<PhrasesCubit>().selectCategory(cat),
              ),
              Expanded(
                child: ListView.builder(
                  key: const PageStorageKey('homeList'),
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    return PhraseCard(
                      phrase: filtered[i],
                      onShare: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Compartilhar: ${filtered[i].text}')),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
