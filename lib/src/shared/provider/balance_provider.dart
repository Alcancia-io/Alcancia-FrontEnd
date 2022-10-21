import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Balance {
  double balance;

  Balance({
    required this.balance,
  });

  factory Balance.fromJSON(double balance) {
    return Balance(
      balance: balance.toDouble(),
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
