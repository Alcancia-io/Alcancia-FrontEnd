import 'package:alcancia/src/shared/models/MFAModel.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:alcancia/src/shared/services/auth_service.dart';

class LoginController {
  Future<MFAResponseModel> completeSignIn(MFAInputModel data) async {
    AuthService authService = AuthService();
    final response = await authService.completeSignIn(data);
    if (response.hasException) {
      return Future.error(response.exception.toString());
    } else if (response.data != null) {
      return MFAResponseModel.fromMap(response.data!["completeMFASignIn"]);
    }
    return Future.error("Unknown MFA error");
  }

  Future<LoginDataModel> signIn(String email, String password) async {
    AuthService authService = AuthService();
    final response = await authService.signIn(email, password);
    if (response.hasException) {
      String? error =
          response.exception?.linkException?.originalException.toString();
      error ??= response.exception?.graphqlErrors.first.extensions?["exception"]
          ?["code"];
      error ??= response.exception.toString();
      return Future.error(error);
    } else if (response.data != null) {
      final data = response.data!;
      final token = data["signIn"]["token"] as String;
      final type = data["signIn"]["type"] as String;
      return LoginDataModel(
          token: token, email: email, password: password, type: type);
    }
    return Future.error("Unknown error");
  }
}
