import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _rc;

  RemoteConfigService._(this._rc);

  static Future<RemoteConfigService> create() async {
    final rc = FirebaseRemoteConfig.instance;
    try {
      await rc.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(seconds: 5), minimumFetchInterval: const Duration(minutes: 5)));
      await rc.fetchAndActivate();
    } catch (_) {
      // ignore fetch errors, we'll fall back to defaults
    }
    return RemoteConfigService._(rc);
  }

  String get phrasesJson => _rc.getString('phrases_text');
  String get imagesJson => _rc.getString('image_text');
}
