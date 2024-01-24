import 'package:alcancia/firebase_remote_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:riverpod/src/framework.dart';

/*LiveTestRemoteConfigService liveTestRemoteConfigService() {
  return LiveTestRemoteConfigService(
      //firebaseRemoteConfigService: firebaseRemoteConfigServiceProvider.read(FirebaseRemoteConfig.instance as Node)); malo
}*/

class LiveTestRemoteConfigService {
  const LiveTestRemoteConfigService({
    required this.firebaseRemoteConfigService,
  });

  final FirebaseRemoteConfigService firebaseRemoteConfigService;

  bool liveBool() {
    print(firebaseRemoteConfigService.getLiveBool());
    return firebaseRemoteConfigService.getLiveBool();
  }
}
