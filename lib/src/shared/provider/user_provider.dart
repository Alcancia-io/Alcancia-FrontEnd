import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/alcancia_models.dart';

class UserState extends StateNotifier<User?> {
  UserState() : super(null);

  Future<void> login(String email, String password) async {
    // This mocks some sort of request / response
    state = User(
      userId: "",
      name: "My Name",
      surname: "My Surname",
      email: "My Email",
      gender: "Gender",
      country: "",
      phoneNumber: "",
      dob: DateTime.now(),
      balance: 0,
      walletAddress: "",
    );
  }

  void setUser(User? user) {
    state = user;
  }

  void setBalance(double balance) {
    state?.balance = balance;
  }

  void setPhoneNumber(String phone) {
    state?.phoneNumber = phone;
  }

  Future<void> logout() async {
    // In this example user==null iff we're logged out
    state = null; // No request is mocked here but I guess we could
  }
}

final userProvider = StateNotifierProvider<UserState, User?>((ref) {
  return UserState();
});
