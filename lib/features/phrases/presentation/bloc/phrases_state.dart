import '../../../../shared/models/phrase.dart';

abstract class PhrasesState {}

class PhrasesLoading extends PhrasesState {}

class PhrasesLoaded extends PhrasesState {
  final List<Phrase> all;
  final List<String> categories;
  final String selectedCategory;

  PhrasesLoaded({required this.all, required this.categories, required this.selectedCategory});
}

class PhrasesError extends PhrasesState {
  final String message;
  PhrasesError(this.message);
}
