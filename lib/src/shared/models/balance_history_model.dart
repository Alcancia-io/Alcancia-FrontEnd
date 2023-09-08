import 'dart:ffi';

class UserBalanceHistory {
  final double? balance;
  final String? id;
  final DateTime? createdAt;

  UserBalanceHistory({this.balance, this.id, this.createdAt});

  factory UserBalanceHistory.fromJson(Map<String, dynamic> map) {
    final date = DateTime.parse(map["createdAt"].toString());
    return UserBalanceHistory(
      balance: double.tryParse(map["balance"].toString()),
      id: map['id'].toString(),
      createdAt: date,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['id'] = id;
    data['createdAt'] = createdAt;
    return data;
  }
}
