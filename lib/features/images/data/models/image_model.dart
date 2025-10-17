import 'package:phrases_to_share/shared/models/image_item.dart';

class ImageModel {
  final String url;
  final String category;

  const ImageModel({required this.url, required this.category});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'] as String? ?? '',
      category: json['category'] as String? ?? 'Todas',
    );
  }

  ImageItem toEntity() => ImageItem(url: url, category: category);
}
