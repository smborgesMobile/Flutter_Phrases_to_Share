import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/images_cubit.dart';
import '../../../../shared/widgets/image_card/image_card.dart';
import '../../../phrases/presentation/widgets/category_chips.dart';

class ImagesPage extends StatelessWidget {
  const ImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesCubit, ImagesState>(
      builder: (context, state) {
        if (state is ImagesLoading) return const Center(child: CircularProgressIndicator());
        if (state is ImagesError) return Center(child: Text('Erro: ${state.message}'));
        if (state is ImagesLoaded) {
          final cats = state.categories;
          final selected = state.selectedCategory;
          final filtered = selected == 'Todas' ? state.all : state.all.where((i) => i.category == selected).toList();
          return Column(
            children: [
              CategoryChips(
                categories: cats,
                selected: selected,
                onSelected: (cat) => context.read<ImagesCubit>().selectCategory(cat),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => ImageCard(item: filtered[i]),
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
