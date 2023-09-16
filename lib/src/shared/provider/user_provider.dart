import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/alcancia_models.dart';

class UserState extends StateNotifier<User?> {
  UserState() : super(null);

  void setUser(User? user) {
    state = user;
  }

  void setPhoneNumber(String phone) {
    state?.phoneNumber = phone;
  }

  Future<void> logout() async {
    // In this example user==null iff we're logged out
    state = null; // No request is mocked here but I guess we could
  }

  void setReferralCode(String code) {
    state?.referralCode = code;
  }
}

final userProvider = StateNotifierProvider<UserState, User?>((ref) {
  return UserState();
});
