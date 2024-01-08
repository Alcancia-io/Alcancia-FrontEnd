class LoginDataModel {
  String token;
  final String email;
  final String password;
  final String type;
  bool rememberMe;

  LoginDataModel(
      {required this.token, required this.email, required this.password, required this.type, this.rememberMe = false});
}
