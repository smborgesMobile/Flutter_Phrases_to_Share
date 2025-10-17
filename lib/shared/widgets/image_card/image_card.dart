import 'package:flutter/material.dart';
import '../../../shared/models/image_item.dart';
import '../../../core/shared_store.dart';

class ImageCard extends StatelessWidget {
  final ImageItem item;

  const ImageCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(item.url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image))),
          Positioned(
            bottom: 6,
            left: 6,
            right: 6,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(item.category, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: IconButton(
              onPressed: () {
                SharedStore.instance.add(SharedEntry.image(item));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagem adicionada aos compartilhados')));
              },
              icon: const Icon(Icons.share, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
