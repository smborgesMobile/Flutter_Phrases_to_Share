import 'package:flutter/material.dart';
import '../../../shared/models/image_item.dart';
import '../../../core/shared_store.dart';
import '../../../core/share_helpers_native.dart';
import '../../../../features/images/presentation/pages/image_preview_page.dart';

class ImageCard extends StatelessWidget {
  final ImageItem item;

  const ImageCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ImagePreviewPage(item: item)));
            },
            child: Hero(
              tag: item.url,
              child: Image.network(
                item.url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 6,
            right: 6,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                item.category,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: IconButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await shareImageNative(item.url, caption: item.category);
                  SharedStore.instance.add(SharedEntry.image(item));
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Imagem compartilhada e salva'),
                    ),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Erro ao compartilhar: $e')),
                  );
                }
              },
              icon: const Icon(Icons.share, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
