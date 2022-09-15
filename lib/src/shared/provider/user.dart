import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final String userId;
  final String email;
  final String name;
  final String surname;
  final String gender;
  String phoneNumber;
  final DateTime dob;


  User({required this.userId, required this.surname, required this.gender, required this.phoneNumber, required this.dob, required this.name, required this.email});
}

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
      phoneNumber: "",
      dob: DateTime.now(),
    );
  }

  void setPhoneNumber(String phone) {
    state?.phoneNumber = phone;
  }

  void setUser(User user) {
    state = user;
  }

  Future<void> logout() async {
    // In this example user==null iff we're logged out
    state = null; // No request is mocked here but I guess we could
  }
}

final userProvider = StateNotifierProvider<UserState, User?>((ref) {
  return UserState();
});
