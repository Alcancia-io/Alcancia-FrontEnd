import 'dart:convert';
import 'dart:developer';

import 'package:alcancia/src/shared/models/remote_config_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseRemoteConfigServiceProvider {
  const FirebaseRemoteConfigServiceProvider({
    required this.remoteConfig,
  });
  final FirebaseRemoteConfig remoteConfig;

  Future<void> init() async {
    try {
      var remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.ensureInitialized();
      await remoteConfig.fetchAndActivate();
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero));
    } on FirebaseException catch (e, s) {
      log("Unable to init remote config", error: e, stackTrace: s);
    }
    const defaultJson = <String, dynamic>{
      'MinimumAppVersion': '1.0.0',
      'DO': {
        'enabled': false,
        'Currencies': {
          'USD': {
            'enabled': true,
            'currencyCode': 'USD',
            'icon': 'assets/images/usd.png',
            'minAmount': 100,
            'maxAmount': 1000,
            'Banks': {
              'BHD': {
                'enabled': true,
                'info1': 'Info 1',
                'info2': 'Info 2',
                'info3': 'Info 3',
              },
              'XYZ': {
                'enabled': true,
                'info1': 'Info 1',
                'info2': 'Info 2',
                'info3': 'Info 3',
              },
            },
          },
        },
      },
    };
    await remoteConfig.setDefaults({"app_variables": json.encode(defaultJson)});
  }

  String getAppVariables() => remoteConfig.getString("app_variables");

  RemoteConfigData parseRemoteConfigData(json) {
    try {
      final Map<String, dynamic> data = jsonDecode(json);
      final Map<String, dynamic>? configData = data['config'];

      if (configData != null) {
        final Map<String, dynamic>? countryConfigJson = configData['country'];
        if (countryConfigJson != null) {
          return RemoteConfigData.fromJson(countryConfigJson);
        } else {
          throw FormatException(
              "Invalid JSON format: 'country' key not found or null");
        }
      } else {
        throw FormatException(
            "Invalid JSON format: 'config' key not found or null");
      }
    } catch (e) {
      throw e;
    }
  }
}

final firebaseRemoteConfigServiceProvider =
    Provider<FirebaseRemoteConfigServiceProvider>((ref) {
  return FirebaseRemoteConfigServiceProvider(
      remoteConfig: FirebaseRemoteConfig.instance);
});

final remoteConfigDataStateProvider = StateProvider<RemoteConfigData>((ref) {
  return RemoteConfigData(countryConfig: {});
});
