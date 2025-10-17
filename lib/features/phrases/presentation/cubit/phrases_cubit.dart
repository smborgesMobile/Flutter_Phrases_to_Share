import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_phrases.dart';
import '../../../../../shared/models/phrase.dart';
import '../bloc/phrases_state.dart';

class PhrasesCubit extends Cubit<PhrasesState> {
  final GetPhrases getPhrases;

  PhrasesCubit({required this.getPhrases}) : super(PhrasesLoading());

  Future<void> fetch() async {
    emit(PhrasesLoading());
    try {
  final res = await getPhrases();
  final List<Phrase> phrases = List<Phrase>.from(res);
  final cats = <String>{'Todas'}..addAll(phrases.map((e) => e.category));
  emit(PhrasesLoaded(all: phrases, categories: cats.toList(), selectedCategory: 'Todas'));
    } catch (e) {
      emit(PhrasesError(e.toString()));
    }
  }

  void selectCategory(String c) {
    final current = state;
    if (current is PhrasesLoaded) {
      emit(PhrasesLoaded(all: current.all, categories: current.categories, selectedCategory: c));
    }
  }
}
