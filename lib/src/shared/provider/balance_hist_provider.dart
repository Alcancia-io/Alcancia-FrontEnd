import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/balance_history_model.dart';

final balanceHistProvider = StateProvider<List<UserBalanceHistory>>((ref) {
  return [];
});
