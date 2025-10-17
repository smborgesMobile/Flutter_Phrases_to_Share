abstract class PhrasesEvent {}

class FetchPhrases extends PhrasesEvent {}

class SelectCategory extends PhrasesEvent {
  final String category;
  SelectCategory(this.category);
}
