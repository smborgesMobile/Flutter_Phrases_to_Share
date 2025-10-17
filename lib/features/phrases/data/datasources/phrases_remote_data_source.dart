import 'dart:convert';

import '../models/phrase_model.dart';

abstract class PhrasesRemoteDataSource {
  Future<List<PhraseModel>> fetchPhrasesFromJson(String jsonString);
}

class PhrasesRemoteDataSourceImpl implements PhrasesRemoteDataSource {
  @override
  Future<List<PhraseModel>> fetchPhrasesFromJson(String jsonString) async {
    final Map<String, dynamic> data = json.decode(jsonString) as Map<String, dynamic>;
    final items = data['phrases'] as List<dynamic>? ?? [];
    return items.map((e) => PhraseModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
