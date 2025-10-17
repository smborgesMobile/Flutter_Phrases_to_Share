import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_phrases.dart';
import '../../../../shared/models/phrase.dart';

class PhrasesController extends ChangeNotifier {
  final GetPhrases getPhrases;

  List<Phrase> _all = [];
  List<Phrase> get all => _all;

  List<String> _categories = ['Todas'];
  List<String> get categories => _categories;

  String _selectedCategory = 'Todas';
  String get selectedCategory => _selectedCategory;

  bool _loading = false;
  bool get loading => _loading;

  PhrasesController({required this.getPhrases});

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    final res = await getPhrases();
    _all = List<Phrase>.from(res);
    final cats = <String>{'Todas'}..addAll(_all.map((e) => e.category));
    _categories = cats.toList();
    _loading = false;
    notifyListeners();
  }

  void selectCategory(String c) {
    _selectedCategory = c;
    notifyListeners();
  }

  List<Phrase> filtered() {
    if (_selectedCategory == 'Todas') return _all;
    return _all.where((p) => p.category == _selectedCategory).toList();
  }
}
