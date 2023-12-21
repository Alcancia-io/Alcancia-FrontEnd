import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:firebase_auth/firebase_auth.dart' as user_fire;

class UserRegistrationModel {
  const UserRegistrationModel(
      {required this.user, required this.password, this.thirdSignin});
  final User user;
  final String password;
  final bool? thirdSignin;
}

class RegistrationParam {
  const RegistrationParam(
      {required this.user, required this.isCompleteRegistration});
  final bool? isCompleteRegistration;
  final user_fire.User? user;
}
