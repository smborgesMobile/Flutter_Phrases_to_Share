import '../../../images/data/datasources/images_remote_data_source.dart';
import '../../../../../shared/models/image_item.dart';
import '../../domain/repositories/images_repository.dart';

class ImagesRepositoryImpl implements ImagesRepositoryContract {
  final ImagesRemoteDataSource remote;
  final String jsonPayload;

  ImagesRepositoryImpl({required this.remote, required this.jsonPayload});

  @override
  Future<List<ImageItem>> getImages() async {
    final models = await remote.fetchImagesFromJson(jsonPayload);
    return models.map((m) => m.toEntity()).toList();
  }
}
