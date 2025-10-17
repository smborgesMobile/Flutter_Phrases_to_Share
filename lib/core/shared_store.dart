import 'package:flutter/foundation.dart';
import '../shared/models/image_item.dart';
import '../shared/models/phrase.dart';

enum SharedType { phrase, image }

class SharedEntry {
  final SharedType type;
  final DateTime when;
  final Phrase? phrase;
  final ImageItem? image;

  SharedEntry.phrase(this.phrase)
      : type = SharedType.phrase,
        when = DateTime.now(),
        image = null;

  SharedEntry.image(this.image)
      : type = SharedType.image,
        when = DateTime.now(),
        phrase = null;
}

class SharedStore {
  SharedStore._();
  static final SharedStore instance = SharedStore._();

  final ValueNotifier<List<SharedEntry>> items = ValueNotifier<List<SharedEntry>>([]);

  void add(SharedEntry e) {
    final list = List<SharedEntry>.from(items.value);
    list.insert(0, e);
    items.value = list;
  }

  void clear() => items.value = [];
}
