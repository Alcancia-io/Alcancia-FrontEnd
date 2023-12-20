import 'package:alcancia/src/shared/models/storage_item.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class _BiometricService extends StateNotifier<bool> {
  final localAuth = LocalAuthentication();
  final storageService = StorageService();

  _BiometricService() : super(false);

  Future<bool> deviceSupportsBiometrics() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<void> enrollApp() async {
    try {
      await storageService.writeSecureData(StorageItem("biometric", true.toString()));
    } catch (e) {
      print('Error during biometric enrollment: $e');
      return Future.error(e);
    }
  }

  Future<void> unenrollApp() async {
    try {
      await storageService.writeSecureData(StorageItem("biometric", false.toString()));
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

  Future<void> authenticate() async {
    try {

      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();

        if (availableBiometrics.isNotEmpty) {
          bool isAuthenticated = await localAuth.authenticate(
            localizedReason: 'Authenticate to access the app',
            options: const AuthenticationOptions(
                useErrorDialogs: true, stickyAuth: true, biometricOnly: false),
          );

          state = isAuthenticated;
        } else {
          state = false;
        }
      } else {
        state = true;
      }
    } catch (e) {
      print('Error during biometric authentication: $e');
      state = false;
    }
  }

  Future<bool> initialAuthentication() async {
    try {

      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();

        if (availableBiometrics.isNotEmpty) {
          bool isAuthenticated = await localAuth.authenticate(
            localizedReason: 'Authenticate to access the app',
            options: const AuthenticationOptions(
                useErrorDialogs: true, stickyAuth: true, biometricOnly: false),
          );

          return isAuthenticated;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }
}

final biometricServiceProvider = StateNotifierProvider<_BiometricService, bool>((ref) {
  return _BiometricService();
});

