import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhraseCard extends StatelessWidget {
  final String phrase;
  final VoidCallback? onShare;
  final VoidCallback? onCopy;

  const PhraseCard({
    super.key,
    required this.phrase,
    this.onShare,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    void defaultCopy() {
      Clipboard.setData(ClipboardData(text: phrase));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copiado para a área de transferência')),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phrase, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onCopy ?? defaultCopy,
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copiar'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Compartilhar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
