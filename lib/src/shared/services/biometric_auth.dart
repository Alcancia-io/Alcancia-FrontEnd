import 'package:local_auth/local_auth.dart';

class BiometricService {
  Future<bool> authenticate() async {
    try {
      var localAuth = LocalAuthentication();

      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();

        if (availableBiometrics.isNotEmpty) {
          bool isAuthenticated = await localAuth.authenticate(
            localizedReason: 'Authenticate to access the app',
            options: const AuthenticationOptions(
                useErrorDialogs: true, stickyAuth: true),
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
