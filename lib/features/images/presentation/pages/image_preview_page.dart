import 'package:flutter/material.dart';
import '../../../../shared/models/image_item.dart';
import '../../../../core/share_helpers_native.dart';
import '../../../../core/shared_store.dart';
import 'package:share_plus/share_plus.dart';

class ImagePreviewPage extends StatefulWidget {
  final ImageItem item;

  const ImagePreviewPage({super.key, required this.item});

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
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
          _isSharing
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Center(
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation(Colors.white))),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    setState(() => _isSharing = true);
                    try {
                      final file = await prepareSharedImageFile(item.url);
                      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
                      SharedStore.instance.add(SharedEntry.image(item));
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(content: Text('Erro ao compartilhar: $e')));
                    } finally {
                      if (mounted) setState(() => _isSharing = false);
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
