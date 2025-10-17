import '../repositories/phrases_repository.dart';

class GetPhrases {
  final PhrasesRepository repository;

  GetPhrases(this.repository);

  Future<List> call() async {
    return repository.fetchPhrases();
  }
}
