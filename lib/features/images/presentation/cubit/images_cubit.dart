import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_images.dart';
import '../../../../../shared/models/image_item.dart';

abstract class ImagesState {}
class ImagesLoading extends ImagesState {}
class ImagesLoaded extends ImagesState {
  final List<ImageItem> all;
  final List<String> categories;
  final String selectedCategory;

  ImagesLoaded({required this.all, required this.categories, required this.selectedCategory});
}
class ImagesError extends ImagesState {
  final String message;
  ImagesError(this.message);
}

class ImagesCubit extends Cubit<ImagesState> {
  final GetImages getImages;

  ImagesCubit({required this.getImages}) : super(ImagesLoading());

  Future<void> fetch() async {
    emit(ImagesLoading());
    try {
      final res = await getImages();
      final List<ImageItem> images = List<ImageItem>.from(res);
      final cats = <String>{'Todas'}..addAll(images.map((e) => e.category));
      emit(ImagesLoaded(all: images, categories: cats.toList(), selectedCategory: 'Todas'));
    } catch (e) {
      emit(ImagesError(e.toString()));
    }
  }

  void selectCategory(String c) {
    final current = state;
    if (current is ImagesLoaded) {
      emit(ImagesLoaded(all: current.all, categories: current.categories, selectedCategory: c));
    }
  }
}
