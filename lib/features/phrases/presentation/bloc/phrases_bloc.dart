import 'dart:async';

import '../../domain/usecases/get_phrases.dart';
import '../../../../shared/models/phrase.dart';
import 'phrases_event.dart';
import 'phrases_state.dart';

class PhrasesBloc {
  final GetPhrases getPhrases;

  final _stateController = StreamController<PhrasesState>.broadcast();
  Stream<PhrasesState> get stream => _stateController.stream;

  final _eventController = StreamController<PhrasesEvent>();
  Sink<PhrasesEvent> get eventSink => _eventController.sink;

  List<Phrase> _all = [];
  String _selected = 'Todas';

  PhrasesBloc({required this.getPhrases}) {
    _eventController.stream.listen(_mapEvent);
  }

  void _mapEvent(PhrasesEvent event) async {
    if (event is FetchPhrases) {
      _stateController.add(PhrasesLoading());
      try {
        final res = await getPhrases();
        _all = List<Phrase>.from(res);
        final cats = <String>{'Todas'}..addAll(_all.map((e) => e.category));
        _stateController.add(PhrasesLoaded(all: _all, categories: cats.toList(), selectedCategory: _selected));
      } catch (e) {
        _stateController.add(PhrasesError(e.toString()));
      }
    } else if (event is SelectCategory) {
      _selected = event.category;
      final cats = <String>{'Todas'}..addAll(_all.map((e) => e.category));
      _stateController.add(PhrasesLoaded(all: _all, categories: cats.toList(), selectedCategory: _selected));
    }
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
