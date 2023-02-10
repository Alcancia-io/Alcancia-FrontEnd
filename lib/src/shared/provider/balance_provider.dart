import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Balance {
  double total;
  double aPolUSDC;
  double cUSD;
  double etherscan;
  double mcUSD;

  Balance({
    required this.total,
    required this.aPolUSDC,
    required this.cUSD,
    required this.etherscan,
    required this.mcUSD,
  });

  Balance.fromMap(Map<String, dynamic> map)
      : this(
          total: double.parse(map['total'].toString()),
          aPolUSDC: double.parse(map['aPolUSDC'].toString()),
          cUSD: double.parse(map['cUSD'].toString()),
          etherscan: double.parse(map['etherscan'].toString()),
          mcUSD: double.parse(map['mcUSD'].toString()),
        );

  double get celoBalance {
    return cUSD + mcUSD;
  }

  double get usdcBalance {
    return aPolUSDC + etherscan;
  }
}

class BalanceState extends StateNotifier<Balance> {
  BalanceState() : super(Balance(total: 0, aPolUSDC: 0, cUSD: 0, etherscan: 0, mcUSD: 0));

  void setBalance(Balance balance) {
    state = balance;
  }
}

final balanceProvider = StateNotifierProvider<BalanceState, Balance>((ref) {
  return BalanceState();
});
