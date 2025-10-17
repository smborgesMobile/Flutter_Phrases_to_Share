import '../repositories/phrases_repository.dart';
import '../../../../../shared/models/phrase.dart';

class GetPhrases {
  final PhrasesRepository repository;

  GetPhrases(this.repository);

  Future<List<Phrase>> call() async {
    return repository.fetchPhrases();
  }
}
