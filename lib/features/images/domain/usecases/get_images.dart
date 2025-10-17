import '../repositories/images_repository.dart';

typedef GetImages = Future<List> Function();

GetImages makeGetImages(ImagesRepositoryContract repo) {
  return () async {
    return await repo.getImages();
  };
}
