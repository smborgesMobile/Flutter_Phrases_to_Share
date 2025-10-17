import '../../../../shared/models/phrase.dart';
import '../datasources/phrases_remote_data_source.dart';
import '../../domain/repositories/phrases_repository.dart';

class PhrasesRepositoryImpl implements PhrasesRepository {
  final PhrasesRemoteDataSource remote;
  final String jsonPayload;

  PhrasesRepositoryImpl({required this.remote, required this.jsonPayload});

  @override
  Future<List<Phrase>> fetchPhrases() async {
    final models = await remote.fetchPhrasesFromJson(jsonPayload);
    return models.map((m) => m.toEntity()).toList();
  }
}
