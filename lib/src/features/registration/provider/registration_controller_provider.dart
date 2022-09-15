import 'package:alcancia/src/shared/provider/token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcancia/src/features/registration/model/registration_controller.dart';

final registrationControllerProvider = Provider<RegistrationController>((ref) {
  final token = ref.watch(tokenProvider);
  return RegistrationController(token: token.value ?? "");
});