import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseRemoteConfigService {
  const FirebaseRemoteConfigService({
    required this.firebaseRemoteConfig,
  });
  final FirebaseRemoteConfig firebaseRemoteConfig;

  Future<void> init() async {
    try {
      await firebaseRemoteConfig.ensureInitialized();
      await firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero));
    } on FirebaseException catch (e, s) {
      log("Unable to init remote config", error: e, stackTrace: s);
    }
  }

  //bool getLiveBool() => firebaseRemoteConfig.getBool("test_bool");
}

final firebaseRemoteConfigServiceProvider =
    StateProvider<FirebaseRemoteConfigService>((ref) {
  return FirebaseRemoteConfigService(
      firebaseRemoteConfig: FirebaseRemoteConfig.instance);
});
