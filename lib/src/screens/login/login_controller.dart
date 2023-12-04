import 'package:alcancia/src/shared/models/login_data_model.dart';
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

  Future<LoginDataModel> login(String email, String password, String deviceToken) async {
    AuthService authService = AuthService();
    final response = await authService.login(email, password, deviceToken);
    if (response.hasException) {
      String? error = response.exception?.linkException?.originalException.toString();
      error ??= response.exception?.graphqlErrors.first.message;
      error ??= response.exception.toString();
      return Future.error(error);
    } else if (response.data != null) {
      final data = response.data!;
      final token = data["login"]["access_token"] as String;
      final name = data["login"]["user"]["name"];
      final email = data["login"]["user"]["email"];
      final phoneNumber = data["login"]["user"]["phoneNumber"];
      return LoginDataModel(token: token, name: name, email: email, password: password, phoneNumber: phoneNumber);
    }
    return Future.error("Unknown error");
  }
}
