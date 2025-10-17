import '../../../../shared/models/image_item.dart';

abstract class ImagesRepositoryContract {
  Future<List<ImageItem>> getImages();
}
