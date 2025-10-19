import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> shareTextNative(String text) async {
  try {
    await SharePlus.instance.share(ShareParams(text: text));
  } catch (_) {
    await Share.share(text);
  }
}

Future<void> shareImageNative(String imageUrl, {String? caption}) async {
  // Backwards-compatible wrapper: prepare the file and then share it
  final file = await prepareSharedImageFile(imageUrl);
  if (caption != null && caption.isNotEmpty) {
    await SharePlus.instance.share(ShareParams(text: caption, files: [XFile(file.path)]));
  } else {
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }
}

/// Downloads the image and writes a temporary file that can be shared.
///
/// Returns the [File] pointing to the written temporary image.
Future<File> prepareSharedImageFile(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode != 200) throw Exception('Failed to download image');

  final bytes = response.bodyBytes;
  final tempDir = await getTemporaryDirectory();
  final file = File(
    '${tempDir.path}/shared_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );
  await file.writeAsBytes(bytes);
  return file;
}
