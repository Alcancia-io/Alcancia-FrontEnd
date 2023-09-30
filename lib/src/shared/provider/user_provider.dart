import 'package:alcancia/src/screens/dashboard/dashboard_controller.dart';
import 'package:alcancia/src/screens/referral/referral_controller.dart';
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


final alcanciaUserProvider = FutureProvider<User>((ref) async {
  final controller = DashboardController();
  final referralController = ReferralController();
  final user = await controller.fetchUser();
  final txns = await controller.fetchUserTransactions();
  final balanceHist = await controller.fetchUserBalanceHistory();
  if (await controller.campaignUserExists()){
    final refCode = await referralController.getReferralCode();
    user.referralCode = refCode;
  }
  user.transactions = txns;
  user.balanceHistory = balanceHist;

  return user;
});
