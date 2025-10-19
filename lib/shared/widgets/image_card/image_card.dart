import 'package:flutter/material.dart';
import '../../../shared/models/image_item.dart';
import '../../../core/shared_store.dart';
import '../../../core/share_helpers_native.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../features/images/presentation/pages/image_preview_page.dart';

class ImageCard extends StatefulWidget {
  final ImageItem item;

  const ImageCard({super.key, required this.item});

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
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
              child: CachedNetworkImage(
                imageUrl: item.url,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
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
          // Share button
          Positioned(
            top: 6,
            right: 6,
            child: _isSharing
                ? const SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)),
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      setState(() => _isSharing = true);
                      try {
                        final file = await prepareSharedImageFile(item.url);
                        // call share with file
                        await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
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
                      } finally {
                        if (mounted) setState(() => _isSharing = false);
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
