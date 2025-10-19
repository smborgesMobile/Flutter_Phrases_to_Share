import 'package:flutter/material.dart';
import '../../../../shared/models/image_item.dart';
import '../../../../core/share_helpers_native.dart';
import '../../../../core/shared_store.dart';

class ImagePreviewPage extends StatelessWidget {
  final ImageItem item;

  const ImagePreviewPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await shareImageNative(item.url, caption: "");
                SharedStore.instance.add(SharedEntry.image(item));
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('Erro ao compartilhar: $e')));
              }
            },
          )
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Hero(
            tag: item.url,
            child: Image.network(
              item.url,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white, size: 64),
            ),
          ),
        ),
      ),
      // using AppBar action (white share icon) instead of FAB for a cleaner look
    );
  }
}
