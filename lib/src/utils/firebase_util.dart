import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseUtil {
  FirebaseUtil._();

  static Future<Map<String, String>> remoteConfig([Map<String, String> defaults]) async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.setDefaults(defaults ?? {});

    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    return remoteConfig.getAll().map((key, value) => MapEntry(key, value.asString()));
  }
}
