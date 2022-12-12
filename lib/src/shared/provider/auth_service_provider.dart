import 'package:alcancia/src/shared/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});