import 'package:flutter/material.dart';
import '../../../../core/shared_store.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compartilhados'), actions: [
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: () => SharedStore.instance.clear(),
        )
      ]),
      body: ValueListenableBuilder<List<SharedEntry>>(
        valueListenable: SharedStore.instance.items,
        builder: (context, items, _) {
          if (items.isEmpty) return const Center(child: Text('Nada compartilhado ainda'));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final e = items[i];
              if (e.type == SharedType.phrase) {
                return ListTile(
                  leading: const Icon(Icons.format_quote),
                  title: Text(e.phrase?.text ?? ''),
                  subtitle: Text(e.phrase?.category ?? ''),
                );
              }
              return ListTile(
                leading: e.image != null ? Image.network(e.image!.url, width: 64, height: 64, fit: BoxFit.cover) : const Icon(Icons.image),
                title: Text(e.image?.category ?? ''),
                subtitle: Text('${e.when}'),
              );
            },
          );
        },
      ),
    );
  }
}
