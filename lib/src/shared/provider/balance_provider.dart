import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Balance {
  double balance;

  Balance({
    required this.balance,
  });

  factory Balance.fromJSON(Map<String, dynamic>? map) {
    return Balance(
      balance: map?['getWalletBalance'].toDouble(),
    );
  }
}

class BalanceState extends StateNotifier<Balance?> {
  BalanceState() : super(null);

  void setBalance(Balance balance) {
    state = balance;
  }
}

final balanceProvider = StateNotifierProvider<BalanceState, Balance?>((ref) {
  return BalanceState();
});
