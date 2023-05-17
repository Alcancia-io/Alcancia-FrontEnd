import 'package:alcancia/src/shared/services/auth_service.dart';

class LoginController {
  Future<bool> completeSignIn(String verificationCode) async {
    AuthService authService = AuthService();
    final response = await authService.completeSignIn(verificationCode);
    if (response.hasException) {
      return Future.error(response.exception.toString());
    } else if (response.data != null) {
      return response.data!["completeSignIn"] as String == "SUCCESS";
    }
    return false;
  }

  Future<String> login(String email, String password, String deviceToken) async {
    AuthService authService = AuthService();
    final response = await authService.login(email, password, deviceToken);
    if (response.hasException) {
      return Future.error(response.exception.toString());
    } else if (response.data != null) {
      final data = response.data!;
      final token = data["login"]["access_token"] as String;
      return token;
    }
    return Future.error("Unknown error");
  }
}
