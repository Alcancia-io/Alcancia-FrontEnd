class LoginDataModel {
  final String token;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const LoginDataModel(
      {required this.token, required this.name, required this.email, required this.password, required this.phoneNumber});
}
