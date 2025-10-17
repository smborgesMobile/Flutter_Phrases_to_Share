import 'dart:convert';

import '../models/image_model.dart';

abstract class ImagesRemoteDataSource {
  Future<List<ImageModel>> fetchImagesFromJson(String jsonString);
}

class ImagesRemoteDataSourceImpl implements ImagesRemoteDataSource {
  @override
  Future<List<ImageModel>> fetchImagesFromJson(String jsonString) async {
    final Map<String, dynamic> data = json.decode(jsonString) as Map<String, dynamic>;
    final items = data['images'] as List<dynamic>? ?? [];
    return items.map((e) => ImageModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
