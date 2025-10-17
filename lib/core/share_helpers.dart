import 'package:url_launcher/url_launcher.dart';

Future<void> shareTextToWhatsApp(String text) async {
  final encoded = Uri.encodeComponent(text);
  final httpsUrl = Uri.parse('https://wa.me/?text=$encoded');
  final schemeUrl = Uri.parse('whatsapp://send?text=$encoded');

  if (await canLaunchUrl(httpsUrl)) {
    await launchUrl(httpsUrl);
    return;
  }
  if (await canLaunchUrl(schemeUrl)) {
    await launchUrl(schemeUrl);
    return;
  }
  throw Exception('Could not launch WhatsApp');
}

Future<void> shareImageUrlToWhatsApp(String imageUrl, [String? caption]) async {
  final text = '${caption ?? ''}\n$imageUrl';
  return shareTextToWhatsApp(text);
}
