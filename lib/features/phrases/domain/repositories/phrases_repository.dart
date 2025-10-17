import '../../../../../shared/models/phrase.dart';

abstract class PhrasesRepository {
  Future<List<Phrase>> fetchPhrases();
}
