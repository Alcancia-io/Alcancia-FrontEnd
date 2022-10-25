import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/alcancia_models.dart';

class UserState extends StateNotifier<User?> {
  UserState() : super(null);

  void setUser(User user) {
    state = user;
  }
}

final userProvider = StateNotifierProvider<UserState, User?>((ref) {
  return UserState();
});
