import 'package:phrases_to_share/shared/models/phrase.dart';

class PhraseModel {
  final String text;
  final String category;

  const PhraseModel({required this.text, required this.category});

  factory PhraseModel.fromJson(Map<String, dynamic> json) {
    return PhraseModel(
      text: json['text'] as String? ?? '',
      category: json['category'] as String? ?? 'Todas',
    );
  }

  Phrase toEntity() => Phrase(text: text, category: category);
}
