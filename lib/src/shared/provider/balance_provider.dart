import 'package:flutter_riverpod/flutter_riverpod.dart';

class Balance {
  double total;

  Balance({
    required this.total,
  });

  Balance.fromMap(Map<String, dynamic> map)
      : this(
          total: double.parse(map['total'].toString()),
        );
}

class BalanceState extends StateNotifier<Balance> {
  BalanceState()
      : super(Balance(
            total: 0));

  void setBalance(Balance balance) {
    state = balance;
  }
}

final balanceProvider = StateNotifierProvider<BalanceState, Balance>((ref) {
  return BalanceState();
});
