import 'package:alcancia/src/shared/models/alcancia_models.dart';

class UserRegistrationModel {
  const UserRegistrationModel({required this.user, required this.password});

  final User user;
  final String password;
}
