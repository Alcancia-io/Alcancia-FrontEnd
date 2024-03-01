import 'package:alcancia/src/shared/models/storage_item.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService extends StateNotifier<bool> {
  static final instance = BiometricService._();

  final localAuth = LocalAuthentication();
  final storageService = StorageService();

  BiometricService._() : super(false);

  Future<bool> deviceSupportsBiometrics() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<void> enrollApp() async {
    try {
      await storageService
          .writeSecureData(StorageItem("biometric", true.toString()));
    } catch (e) {
      print('Error during biometric enrollment: $e');
      return Future.error(e);
    }
  }

  Future<void> unenrollApp() async {
    try {
      await storageService
          .writeSecureData(StorageItem("biometric", false.toString()));
    } catch (e) {
      print('Error during biometric unenrollment: $e');
      return Future.error(e);
    }
  }

  Future<bool> isAppEnrolled() async {
    String? biometric = await storageService.readSecureData("biometric");
    if (biometric == true.toString()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> authenticate({String reason = 'Authenticate to access the app'}) async {
    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();

        if (availableBiometrics.isNotEmpty) {
          bool isAuthenticated = await localAuth.authenticate(
            localizedReason: reason,
            options: const AuthenticationOptions(
                useErrorDialogs: true, stickyAuth: true, biometricOnly: false),
          );

          state = isAuthenticated;
          return isAuthenticated;
        } else {
          state = false;
          return false;
        }
      } else {
        state = true;
        return true;
      }
    } catch (e) {
      print('Error during biometric authentication: $e');
      state = false;
      return false;
    }
  }

  Future<void> unauthenticate() async {
    state = false;
  }

}

final biometricServiceProvider =
    StateNotifierProvider<BiometricService, bool>((ref) {
  return BiometricService.instance;
});
final biometricLockProvider = StateProvider<bool>((ref) {
  return false;
});
